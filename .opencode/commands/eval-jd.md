---
description: Evaluate a job description against the resume and recommend tailoring moves
agent: plan
---

You are evaluating a job description (JD) against Detim Zhao's resume to determine fit and
recommend tailoring moves. DO NOT modify any files — this is a read-only analysis.

## Steps

1. **Read the current resume source files:**
   - `src/heading.tex`, `src/skills.tex`, `src/experience.tex`, `src/projects.tex`, `src/education.tex`

2. **Read the full inventory files** to identify hidden/available content:
   - `src-master/experience.tex`, `src-master/projects.tex`

3. **Read `AGENTS.md`** for tailoring rules and constraints.

4. **Analyze the JD** (provided below after the command) against the resume.

5. **Output a structured evaluation:**

### Fit Assessment
- **Overall fit**: Strong / Decent / Weak
- **Reasoning**: 2-3 sentences on why

### Keyword/Skill Gap Analysis
Table format:

| JD Requirement | Resume Has It? | Action |
|---------------|----------------|--------|
| (keyword)     | Yes/No/Partial | Surface / Reword / Missing |

### Tailoring Moves (Prioritized)
Numbered list of specific changes, grouped by file:

**src/skills.tex:**
- [ ] Move X to top / Add Y / Reorder Z

**src/experience.tex:**
- [ ] Reword bullet: "old text" → "new text" (matches JD keyword: ...)
- [ ] Reorder: move bullet about X to position 1 in role Y
- [ ] Uncomment role stub: (Company, Role) from src-master/

**src/projects.tex:**
- [ ] Uncomment project A from src-master/ (matches JD: ...)
- [ ] Reorder: move project B first
- [ ] Drop project C (least relevant)

**src/heading.tex:**
- [ ] (Usually leave as-is, or add title line if JD demands it)

### What's Missing (Cannot Fix)
List any hard JD requirements that don't appear anywhere in the resume or src-master/.
These require real new experience/skills — do not fabricate.

### Verdict
- **Apply?**: Yes / Maybe / No
- **Tailoring effort**: Low / Medium / High (how much rewriting needed)
- **Key risk**: (biggest gap the resume can't close)

---

## JD to evaluate:

$ARGUMENTS
