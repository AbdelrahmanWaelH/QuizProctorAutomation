# Proctor Scheduling System in Prolog

This Prolog-based system automates TA assignments for quizzes, considering their availability and teaching schedules.

## Features

- **Computes Free Schedules:** Determines each TA’s availability.
- **Merges Schedules:** Creates a unified availability list.
- **Slot Permutation:** Generates assignment options.
- **Quiz Assignment:** Ensures enough proctors are available.

## Predicates

- `assign_proctors/4` – Main assignment function.
- `free_schedule/3` – Computes TA availability.
- `taFreeWeek/3` – Finds a TA’s weekly free slots.
- `mergeTAs/4`, `mergeTwoWeeks/3` – Merges schedules.
- `permuteSlots/2` – Generates slot permutations.
- `assign_quizzes/3`, `assign_quiz/3` – Assigns TAs to quizzes.
- `pickSome/3` – Selects a specified number of TAs.

## Input Format

### TAs
```prolog
ta(Name, Day_Off).
```

### Teaching Schedule
```prolog
day(DayName, [Slot1, Slot2, Slot3, Slot4, Slot5]).
```

### Quizzes
```prolog
quiz(Course, Day, Slot, Count).
```

## Output Format
```prolog
proctors(quiz(Course, Day, Slot, Count), TA_List).
```

## Usage

1. Load the Prolog file:
   ```prolog
   ?- [your_prolog_file].
   ```
2. Define TAs, schedule, and quizzes.
3. Run:
   ```prolog
   ?- assign_proctors(TAs, Quizzes, TeachingSchedule, ProctoringSchedule).
   ```
4. Review `ProctoringSchedule` for results.

## Example

```prolog
TAs = [ta(alice, mon), ta(bob, tue), ta(carol, wed)].
TeachingSchedule = [
    day(sat, [[alice], [], [bob], [], [carol]]),
    day(sun, [[], [bob], [], [carol], []]),
    day(mon, [[alice], [], [bob], [], [carol]])
].
Quizzes = [quiz(math101, mon, 2, 2), quiz(cs101, wed, 3, 1)].
?- assign_proctors(TAs, Quizzes, TeachingSchedule, ProctoringSchedule).
```

## Notes

- **Backtracking:** Prolog explores valid assignments automatically.
- **Consistency:** Ensure matching quiz and schedule days.
- **Flexibility:** Different valid assignments may occur.
