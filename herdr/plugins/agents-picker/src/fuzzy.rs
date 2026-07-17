/// Case-insensitive subsequence match with a small scoring heuristic:
/// consecutive matches and word-boundary hits score higher, and shorter
/// haystacks win ties. Returns `None` when `needle` is not a subsequence.
///
/// Runs in a single pass over `haystack` without heap allocation; this is
/// called for every agent on every keystroke.
pub fn score(needle: &str, haystack: &str) -> Option<i64> {
    let mut needle = lowercase_chars(needle);
    let Some(mut wanted) = needle.next() else {
        return Some(0);
    };

    let mut total = 0i64;
    let mut haystack_len = 0i64;
    let mut exhausted = false;
    let mut previous_matched = false;
    let mut previous_char: Option<char> = None;

    for c in lowercase_chars(haystack) {
        haystack_len += 1;
        if !exhausted && c == wanted {
            total += 1;
            if previous_matched {
                total += 2;
            }
            if previous_char.is_none_or(is_boundary) {
                total += 3;
            }
            previous_matched = true;
            match needle.next() {
                Some(next) => wanted = next,
                None => exhausted = true,
            }
        } else {
            previous_matched = false;
        }
        previous_char = Some(c);
    }

    exhausted.then_some(total * 100 - haystack_len)
}

/// Char indices into `haystack` matched by the same greedy left-to-right walk
/// as `score`, for highlighting. Returns `None` when `needle` is not a
/// subsequence, `Some(vec![])` for an empty needle.
pub fn positions(needle: &str, haystack: &str) -> Option<Vec<usize>> {
    let mut needle = lowercase_chars(needle);
    let Some(mut wanted) = needle.next() else {
        return Some(Vec::new());
    };

    let mut matched = Vec::new();
    // Lowercasing can expand one char into several; tag each expanded char
    // with the index of the original char so highlights map back correctly.
    let indexed = haystack
        .chars()
        .enumerate()
        .flat_map(|(i, c)| c.to_lowercase().map(move |lower| (i, lower)));
    for (i, c) in indexed {
        if c == wanted {
            matched.push(i);
            let Some(next) = needle.next() else {
                matched.dedup();
                return Some(matched);
            };
            wanted = next;
        }
    }
    None
}

fn lowercase_chars(text: &str) -> impl Iterator<Item = char> + '_ {
    text.chars().flat_map(char::to_lowercase)
}

fn is_boundary(c: char) -> bool {
    matches!(c, ' ' | '/' | '-' | '_' | ':' | '.' | '·')
}

#[cfg(test)]
mod tests {
    use super::{positions, score};

    #[test]
    fn empty_needle_matches_everything() {
        assert_eq!(score("", "anything"), Some(0));
    }

    #[test]
    fn matches_subsequence_case_insensitively() {
        assert!(score("dlon", "DealOn Review").is_some());
        assert!(score("DLON", "dealon review").is_some());
    }

    #[test]
    fn rejects_non_subsequence() {
        assert_eq!(score("xyz", "dealon"), None);
        assert_eq!(score("ba", "ab"), None);
    }

    #[test]
    fn consecutive_and_boundary_matches_score_higher() {
        let consecutive = score("deal", "dealon").unwrap();
        let scattered = score("deal", "dxexaxlon").unwrap();
        assert!(consecutive > scattered);

        let boundary = score("app", "my app").unwrap();
        let inner = score("app", "grappa").unwrap();
        assert!(boundary > inner);
    }

    #[test]
    fn positions_track_the_greedy_walk() {
        assert_eq!(
            positions("dlon", "DealOn Review").unwrap(),
            vec![0, 3, 4, 5]
        );
        assert_eq!(positions("", "anything").unwrap(), Vec::<usize>::new());
        assert_eq!(positions("xyz", "dealon"), None);
    }

    #[test]
    fn shorter_haystack_wins_ties() {
        let short = score("cl", "claude").unwrap();
        let long = score("cl", "claude but a much longer label").unwrap();
        assert!(short > long);
    }
}
