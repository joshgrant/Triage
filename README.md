# Triage

Triage is a pretty simple project, aimed at prioritizing your work by pairwise comparisons rather than absolute metrics, inspired by [Elo chess rankings](https://en.wikipedia.org/wiki/Elo_rating_system).

For example, let's say you have feature A and feature B. In a framework like [RICE](https://www.productplan.com/glossary/rice-scoring-model/), you have absolute dimensions, and you score item A along that dimension, and then item B, and compare.

I thought I could make it better by allowing relative comparisons, such that you don't need to know A's "RICE" value, but that you only need to know that A has more reach than B.

Right now, it works only on iOS, but I can pretty easily see it becoming more of a macOS tool if I use it more.

### Dimensions

Right now, I have 6 dimensions:
- User Impact
- Effort
- Goal alignment
- Data confidence
- Urgency
- Dependencies

But I see a very valid scenario where adding or removing dimensions, as well as changing their weight is valuable.
