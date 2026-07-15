# Product Spec — Interactive Storytelling

> Status: Draft  
> Date: 2026-07-15  
> Inspired by: Monkey-style story experience (Reading / Play / Speaking)

---

## 1. Positioning

**An interactive storytelling experience that turns every story into a shared moment for children and their families.**

Kids build **reading**, **comprehension**, and **speaking** skills through guided play, while parents stay involved — reading together, listening to their child, and celebrating progress.

| Audience | Value |
|---|---|
| Child | Understand the story, play with its content, practice speaking aloud |
| Parent | Stay in the loop, listen along, celebrate milestones |
| Family | Shared moments around one story, not isolated screen time |

---

## 2. Product thesis

Every story is not just content to consume. It is a **guided narrative flow** with three modes:

| Mode | Skill focus | Core promise |
|---|---|---|
| **Reading** | Listening + reading along | Guided narration; child follows meaning page by page |
| **Play** | Comprehension | Mini-games woven from the story's own pages, images, and text |
| **Speaking** | Oral reading / expression | Child reads aloud; app + parents listen and celebrate |

The app prompts the child naturally so they grasp the story's meaning through **pre-built mini-games** built from that story's content — not generic quizzes disconnected from the book.

---

## 3. High-level user journey

```text
Home / Story list
  → free + purchasable stories
  → open a story
    → Story hub (3 modes)
        → Reading
        → Play
        → Speaking
    → Progress / celebration (child + parent)
```

### 3.1 Story list

- Show catalog of stories (free and purchasable).
- Surface cover, title, level, duration, progress, favorite.
- Entry point into a single story's **3 modes**.

### 3.2 Story hub (per story)

After selecting a story, present three clear entry points:

1. **Reading** — listen / read along  
2. **Play** — comprehension games from story content  
3. **Speaking** — read aloud challenge  

Rules of thumb:

- Reading can unlock or warm up Play / Speaking (optional gating TBD).
- Parent can join or observe from any mode.
- Progress is visible at story and mode level.

---

## 4. Mode specs

### 4.1 Reading

**Goal:** Child experiences the full narrative with guided audio and on-screen text.

| Capability | Description |
|---|---|
| Page flow | Story unfolds page by page with image + text |
| Narration | Story audio with karaoke / word highlight timing |
| Auto page turn | Follow audio timeline; allow manual swipe |
| Parent presence | Parent can listen together; optional pause / replay |
| Completion | After last page → celebration + next-step prompts |

**Exit options after Reading:**

- Listen again  
- Go to Play  
- Go to Speaking  
- Back to story hub / home  

**Current codebase alignment:**

- ✅ Story list + reader with audio karaoke  
- ✅ Completion screen with “listen again” / “play game”  
- ⬜ Explicit Story hub with 3 modes  
- ⬜ Parent co-listen UX polish  

---

### 4.2 Play

**Goal:** Deepen comprehension through mini-games built from **this story's** pages, images, and lines — not generic templates with unrelated assets.

| Principle | Detail |
|---|---|
| Story-native | Pieces, prompts, and answers come from the story content |
| Guided | Soft prompts so the child discovers meaning without feeling tested |
| Scalable | Works for short (3 pages) and long (20+ pages) stories |
| Delight | Celebrate correct sequences; gentle retry on mistakes |

#### Baseline game (v1)

**Page-order puzzle**

- Pieces = page images in story order.  
- Child arranges them into the correct narrative sequence.  
- For many pages: split into **rounds of 3–5 pages** (see §6).

#### Future mini-game catalog (from story content)

| Game idea | Comprehension skill |
|---|---|
| Page order puzzle | Sequence / plot order |
| “Who said that?” | Character / dialogue |
| Match line → image | Text–image binding |
| Find the moment | Locate scene from a prompt |
| Fill the missing page | Memory of middle of story |
| Emotion / feeling pick | Empathy / tone |

**Current codebase alignment:**

- ✅ Page-order puzzle game (tap + drag)  
- ⬜ Round chunking for long stories  
- ⬜ Game catalog beyond order puzzle  
- ⬜ Play mode entry from Story hub  

---

### 4.3 Speaking

**Goal:** Turn the story into a fun speaking challenge — child reads aloud (Rumble-style), while the **app and parents listen along**, deepening connection to the story.

| Capability | Description |
|---|---|
| Prompt | Show page text; invite child to read aloud |
| Listen | App captures speech (ASR / scoring TBD) |
| Parent listen | Parent can hear live or review recording |
| Feedback | Encouraging, age-appropriate; not harsh grading |
| Progress | Stars / stickers / “pages spoken” milestones |

**Open decisions (capture for PRD):**

- On-device vs cloud ASR  
- Scoring: fluency only vs word accuracy vs parent thumbs-up  
- Offline mode requirements  
- Privacy / consent for child voice data  

**Current codebase alignment:**

- ⬜ Speaking mode UI  
- ⬜ Mic capture + evaluation pipeline  
- ⬜ Parent listen / review flow  

---

## 5. Shared narrative flow

Each story **unfolds across screens** with a guided flow:

```text
Cover / intro
  → Reading pages (1…N)
  → Soft comprehension beats (optional inline Play prompts)
  → Completion celebration
  → Offer Play and/or Speaking
```

Design principles:

1. **Prompt naturally** — questions and games feel like part of the story, not a quiz app.  
2. **One job per screen** — avoid dashboard clutter on child-facing surfaces.  
3. **Family moment** — celebration screens invite parent acknowledgment.  
4. **Reuse story assets** — images, lines, voices already in `StoryDetail` / pages.  

---

## 6. Multi-page Play strategy

Long stories must not dump all page images onto one screen.

| Story size | Play strategy |
|---|---|
| 1–5 pages | Single round |
| 6–15 pages | Rounds of 3–4 pages |
| 16+ pages | Rounds of 3–5 + progress `Round X / Y` |

Rules:

- Only load assets for the **current round**.  
- Complete round → next round.  
- All rounds done → story Play complete.  
- Shuffle within round only (never mix distant pages in one round unless intentional “hard mode”).

---

## 7. Monetization (story list)

| Type | Behavior |
|---|---|
| Free stories | Fully playable in all modes (or Reading-only free — TBD) |
| Purchasable stories | Locked until purchase / subscription entitles access |
| Preview | Optional: first pages of Reading free; Play/Speaking locked |

*Exact commerce model (IAP per story vs subscription) is out of scope for this draft; capture in PRD.*

---

## 8. Success metrics (draft)

| Metric | Why |
|---|---|
| % stories with Reading completed | Core engagement |
| % Reading → Play started | Comprehension loop |
| % Reading → Speaking started | Speaking loop |
| Play round completion rate | Game difficulty fit |
| Parent “listen along” sessions | Family positioning |
| Return visits to same story | Re-read / mastery |

---

## 9. Scope for next implementation slice

Suggested build order after this spec:

1. **Story hub** screen with Reading / Play / Speaking entry points  
2. **Play rounds** for page-order puzzle (chunk long stories)  
3. **Speaking v0** — page text + record + playback (parent listens; no hard ASR yet)  
4. Catalog badges for free vs purchasable on story list  
5. Expand Play mini-game types using story text/images  

---

## 10. Non-goals (this draft)

- Full CMS / story authoring tool  
- Real-time multiplayer  
- Generic quiz bank unrelated to story assets  
- Adult-only reading modes  

---

## 11. Open questions

1. Does Reading completion gate Play / Speaking, or are modes freely choosable?  
2. Free vs paid: which modes are locked?  
3. Speaking: parent thumbs-up enough for v1, or need ASR?  
4. Inline Play beats during Reading, or only after completion?  
5. Primary language(s) of content and UI for v1 market?  

---

## 12. Project structure

See **[Project Structure](../project-structure.md)** for:

- Full repository tree (`lib/`, `test/`, `assets/`, `docs/`)
- Architecture layers (Screens → BLoC → Repository / Services)
- Navigation flow (Home → Hub → Reading / Play / Speaking)
- Module reference and where to add new code

---

## Related docs

- [Project Structure](../project-structure.md)
- [Brainstorming](../brainstorming/interactive-storytelling-brainstorm.md)
