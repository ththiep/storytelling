# Brainstorming — Interactive Storytelling Experience

> Session type: Product ideation (structured dump → themes → concepts)  
> Date: 2026-07-15  
> Inputs: Positioning statement, Monkey-style 3 modes, current Flutter prototype  
> Output: Themes, opportunity areas, concept sketches, risks, next decisions  

---

## 0. Seed prompt (given)

> Positioning: An interactive storytelling experience that turns every story into a **shared moment** for children and their families. Kids build reading, comprehension, and speaking skills through guided play, while parents stay involved — reading together, listening to their child, and celebrating progress.
>
> Example from Monkey:
> - Show the story list (free and purchasable stories)
> - Enter a story to open its **3 modes**: Reading / Play / Speaking
> - Each story unfolds across screens with a guided narrative flow
> - The app prompts the child naturally so they grasp meaning through **pre-built mini-games** woven from the story's own content
> - Speaking turns the story into a fun challenge — child reads aloud (as in Rumble) while the app, and parents, listen along

---

## 1. What we already have (prototype ground)

| Area | Today |
|---|---|
| Story list | Mock/API-backed list with cover, progress |
| Reading | Audio + karaoke word timing, swipe pages, auto-turn |
| After Reading | Completion UI → listen again / play game / talk |
| Play | Page-order puzzle (tap + drag), works for few pages |
| Talk | v0 practice screen in progress |
| Story hub | First-class Read / Play / Talk modes |

**Insight:** We now have the spine of **Reading → celebrate → Play/Talk**. The next leap is making Talk real with parent-friendly recording, privacy choices, and gentle feedback.

---

## 2. Brainstorm techniques used

1. **Role storm** — child / parent / product / content creator lenses  
2. **SCAMPER** on “a story” (Substitute, Combine, Adapt, Modify, Put to other use, Eliminate, Reverse)  
3. **How Might We (HMW)** questions  
4. **Crazy 8 concept titles** (compressed to best ones)  
5. **Risk reverse** — how the product fails family positioning  

---

## 3. Role storm

### Child (5–8)

- “I want to feel I finished something magical, not a lesson.”  
- “Games should use *my* story pictures, or I get confused.”  
- “Speaking is scary if a red X appears when I misread.”  
- “I like choosing: listen again OR play OR speak.”  

### Parent

- “I want a moment I can sit with them — not just hand over the phone.”  
- “Show me what they did today in one glance.”  
- “Don’t make me buy blind — preview the story vibe.”  
- “Voice features must feel safe and private.”  

### Product

- Every story = reusable **content engine** for 3 modes.  
- Monetization sits on catalog, not inside reading flow.  
- Differentiation = story-native games + family listen-along.  

### Content / editorial

- Need clear content contracts: pages, images, text, audio, optional game configs.  
- Mini-games should be generatable from structured story data first; hand-authored challenges later.  

---

## 4. How Might We

1. HMW make finishing a story feel like a **family celebration**, not a score screen?  
2. HMW keep Play fun when a story has **20+ pages** without overwhelming the child?  
3. HMW make Speaking feel like **performance for someone who loves them**, not a speech test?  
4. HMW prompt comprehension **inside** the narrative so it doesn’t break immersion?  
5. HMW show free vs paid without making the library feel like a store first?  
6. HMW reuse one story package to power Reading, Play, and Speaking with minimal extra authoring?  

---

## 5. SCAMPER on “the story”

| Lens | Ideas |
|---|---|
| **Substitute** | Replace end quiz with story-piece games; replace star grade with parent high-five |
| **Combine** | Reading page ends with a tiny Play beat (“Who is this?”) then continues |
| **Adapt** | Adapt Rumble-style read-aloud + Monkey story modes into one hub |
| **Modify** | Soft → hard Play rounds; Speaking from echo (listen-repeat) → independent read |
| **Put to other use** | Page images become puzzle tiles; lines become speaking scripts |
| **Eliminate** | Eliminate generic quiz banks; eliminate harsh fail states |
| **Reverse** | Parent reads first page, child reads next; or child Speak then hear “story version” |

---

## 6. Concept sketches

### Concept A — “Story House”

Enter a story → a cozy hub with three doors: Reading / Play / Speaking.  
Doors light up as the child progresses. Parent sees a small “Tonight’s adventure” strip.

### Concept B — “One river, three banks”

Reading is the river (linear narrative). Play and Speaking are banks you can step onto at chapter breaks or after the end — never random teleports mid-sentence unless designed as a soft beat.

### Concept C — “Story DNA games”

Mini-games are compiled from story DNA:

```text
pages[].imageUrl  → puzzle tiles, scene match
pages[].lines     → speaking scripts, “who said it”
words + timing    → karaoke for Reading; optional echo for Speaking
```

Authoring effort stays low if games are rule-generated.

### Concept D — “Listen with me”

Speaking mode always has a parent seat: live listen, or playback later with a simple reaction (clap / heart / star). App feedback is secondary to human feedback.

### Concept E — “Round quests” (long stories)

Play mode = quest map of rounds (3–5 pages each). Child completes “Chapter stones” until the whole story path lights up.

---

## 7. Mini-game ideation (story-woven)

Priority for generation from existing data:

| # | Game | Uses | Age feel |
|---|---|---|---|
| 1 | Page order puzzle | Page images | Easy–medium |
| 2 | Picture ↔ sentence match | Image + line text | Medium |
| 3 | What happens next? | 3 page thumbnails | Medium |
| 4 | Character finder | Cover/page crops + prompt | Easy |
| 5 | Echo line | Short line + mic | Speaking bridge |
| 6 | Missing page | Leave one gap in sequence | Harder |

**Rule:** If a game needs content not in the story package, it is out of v1.

---

## 8. Speaking mode ladder (safer UX)

Don’t jump straight to scored oral reading.

```text
L0  Listen again (Reading)
L1  Echo: hear line → child repeats (no harsh score)
L2  Read page aloud → save recording for parent
L3  Light ASR feedback (optional) + parent reaction
L4  Full story performance / “recital” mode
```

v1 recommendation: **L1–L2** ships family value without heavy ML risk.

---

## 9. Free vs purchasable brainstorm

| Pattern | Pros | Cons |
|---|---|---|
| Free story fully open | Trust, habit | Weak conversion |
| Free Reading, paid Play/Speak | Try narrative | Feels paywalled mid-joy |
| Free first N pages all modes | Clear trial | Abrupt lock |
| Subscription unlocks library | Simple mental model | Needs critical mass of stories |

Brainstorm lean: **few free complete stories** (all modes) + rest purchasable/subscription — reinforces “shared moment” without bait-and-switch mid-Reading.

---

## 10. Failure modes (risk reverse)

| If we do this… | We break positioning |
|---|---|
| Games use random stock art | Not “woven from the story” |
| Speaking shows big red errors | Child shuts down; parent feels judged |
| Modes feel like 3 separate apps | No guided narrative flow |
| Store-first home | Family moment becomes commerce moment |
| All pages in one puzzle | Long stories become unusable |
| No parent surface | “Parents stay involved” is empty marketing |

---

## 11. Crazy-good one-liners (positioning variants)

1. “Every story is a night you spend together.”  
2. “Read it. Play it. Say it — with someone who loves you listening.”  
3. “Comprehension you can touch; speaking someone can hear.”  
4. “The book doesn’t end when the audio stops.”  
5. “From pages to play to voice — one story, three adventures.”  

---

## 12. Prioritization matrix (brainstorm → build)

| Idea | User value | Feasibility now | Suggest |
|---|---|---|---|
| Story hub (3 modes) | High | High | Do next |
| Play rounds for long stories | High | High | Do next |
| Page-order puzzle polish | Medium | Done/iterate | Keep |
| Speaking L1–L2 (echo + record) | High | Medium | Soon |
| Inline Play beats in Reading | Medium | Medium | Later |
| Full ASR scoring | Medium | Low–Med | Later |
| More mini-game types | High | Medium | After hub + rounds |
| Free/paid catalog UX | High | Medium | Parallel with catalog |

---

## 13. Decisions to lock after this brainstorm

1. **Mode access:** free choice vs Reading-gated.  
2. **Play chunk size:** default 3, 4, or 5 pages per round?  
3. **Speaking v1:** record-for-parent only vs echo + record.  
4. **Commerce:** subscription vs per-story for first market.  
5. **Inline vs post-story Play:** where comprehension beats live.  

---

## 14. Session output summary

**Keep**

- Family shared-moment positioning  
- 3-mode story system (Reading / Play / Speaking)  
- Story-native mini-games  
- Guided flow + soft prompts  
- Parent listen-along for Speaking  

**Build next (engineering-facing)**

- Story hub UI  
- Play round engine for many pages  
- Speaking v0 (echo/record)  

**Park**

- Heavy ASR grading  
- Large hand-authored game DSL  
- Complex social/sharing features  

---

## Related docs

- [Product Spec](../spec/product-spec.md)
- [Project Structure](../project-structure.md)
