---
name: eli5
description: Explain a topic, code, error, or document at a named audience's level. Use when the user says "ELI5" or "explain like I'm…", or asks to explain or simplify something for a specific person, age, grade, or role (my manager, my mom, a 5th grader, a designer).
license: MIT
metadata:
  version: "1.0.0"
  sources: "DreambigOu/ELI5 eli5 (MIT, see THIRD_PARTY_NOTICES.md)"
---

# Explain like I'm…

Fit the explanation to the listener: their words, their analogies, their
reason to care. Simplify by leaving things out; everything you keep stays true.

## 1. Name the audience

Take the audience from the request. A bare "ELI5" means age 5. Place it in one
of three classes; an audience not listed below (CEO, journalist, intern) goes
to the nearest class.

| Audience | Class | Analogies from | Tone |
| --- | --- | --- | --- |
| Age 5, kindergarten | Simple | Toys, animals, candy, playground | Enthusiastic favorite teacher |
| Age 10, 5th grade, kids | Simple | School, sports, video games, cartoons | Enthusiastic, encouraging |
| Age 15, middle or high school | Simple; introduce terms with definitions | Phones, social media, gaming | Relaxed and direct, like an older sibling |
| Age 20–30 | Simple, or Technical if the field is theirs | Daily life, work, money | Clear and direct |
| Age 40+ | Simple, or Technical if the field is theirs | Home, career, family | Respectful |
| College student | Technical; terms with brief context | Coursework, theory then practice | Academic |
| Graduate student, engineer | Technical | Tools they already know ("a hash map, but…") | Precise, concise |
| Designer | Technical about users, Simple about internals | User flows, interaction, accessibility | Collaborative |
| Colleague | Technical about shared work | Their part of the work | Practical |
| Manager, director, product manager | Business | Outcomes, risk, cost, timeline; directors add strategy and ROI, PMs add user value and scope | Confident |
| Partner, friend | Simple | Household, shared routines, pop culture | Warm, conversational, like over dinner |
| Parents | Simple | Technology and routines they already use | Patient and respectful |

## 2. Understand the source

Get the essential what and why before translating:

- **Code**: read the files; know its purpose before its mechanism.
- **Error**: find the root cause, not just the message text.
- **Document**: pull out the points that matter to this audience.
- **Concept**: split it into its core parts.

## 3. Explain

Shape every explanation the same way:

1. **What**: one sentence with the essence.
2. **Analogy**: from the audience's row in the table.
3. **Detail**: only as deep as the class allows.
4. **So what**: why it matters to this listener.

Then apply the class:

- **Simple**: plain words, one idea per sentence, concrete before abstract
  ("the server is like a waiter"), addressed to "you". Define any essential
  term in the same sentence. Keep it short.
- **Technical**: proper terms, focus on trade-offs, edge cases, and design
  decisions. Depth is welcome; padding is not.
- **Business**: lead with impact, quantify where you can, end on the decision
  or recommendation ("This means we should…"). Leave implementation out
  unless asked.

Respect the listener at every level: a 5-year-old's version should delight,
a manager's should equip them to decide.

Done when, for this audience: every term is one they know or defined on the
spot, the analogy comes from their world, and the last lines answer "so what".

## Examples

**"ELI5 what a database index is"** (age 5, Simple): "Imagine a huuuge book
with thousands of pages. To find the page about dinosaurs you could flip
through every page… or look at the list at the front! A database index is that
list. It helps the computer find things super fast."

**"Explain this API rate limiting to my manager"** (Business): "The API lets us
make 100 requests a minute. At peak hours we hit that limit, so some user
requests fail. Two options: make fewer calls (1–2 days of work) or pay for a
higher tier ($X/month). I'd recommend…"

**"Break down useEffect for a college student"** (Technical): "useEffect is
React's hook for side effects, work outside rendering such as API calls or
subscriptions. If you've seen class components, it covers componentDidMount,
componentDidUpdate, and componentWillUnmount in one place. The dependency array
controls when it re-runs…"
