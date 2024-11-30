assign_proctors(_, [], _, []).                                                               

assign_proctors(AllTAs, Quizzes,TeachingSchedule,ProctoringSchedule):-
free_schedule(AllTAs, TeachingSchedule, FreeSchedule),
assign_quizzes(Quizzes,FreeSchedule, ProctoringSchedule).

free_schedule([],_,[]).
free_schedule(TAs, TeachingSchedule, FreeSchedule):-
mergeTAs(TAs, TeachingSchedule,[], FreeSetSchedule),
permuteSlots(FreeSetSchedule, FreeSchedule).

taFreeWeek(_,[],[]).
taFreeWeek(ta(Name, Day_Off), [day(DayName, [S1,S2,S3,S4,S5]) | RemDays], [day(DayName, [F1,F2,F3,F4,F5]) | RemFreeDays]):- /*gets the free slots of a ta for an entire week */
((Day_Off = DayName, F1 = [], F2 = [], F3 = [], F4 = [], F5 = []);
(Day_Off \= DayName,
((\+member(Name, S1),F1 = [Name]);(member(Name, S1),F1 = [])),
((\+member(Name, S2),F2 = [Name]);(member(Name, S2),F2 = [])),
((\+member(Name, S3),F3 = [Name]);(member(Name, S3),F3 = [])),
((\+member(Name, S4),F4 = [Name]);(member(Name, S4),F4 = [])),
((\+member(Name, S5),F5 = [Name]);(member(Name, S5),F5 = [])))),
taFreeWeek(ta(Name, Day_Off), RemDays, RemFreeDays),!.

mergeTwoWeeks([],X,X).
mergeTwoWeeks(X,[],X).
mergeTwoWeeks([],[],[]). /*Merge two weeks given that they are ordered the same*/
mergeTwoWeeks([day(Day, [A1,A2,A3,A4,A5])|RemDays1],[day(Day,[B1,B2,B3,B4,B5])|RemDays2],[day(Day, [Z1,Z2,Z3,Z4,Z5])|RemOutput]):-
append(A1,B1,Z1),append(A2,B2,Z2),append(A3,B3,Z3),append(A4,B4,Z4),append(A5,B5,Z5),
mergeTwoWeeks(RemDays1, RemDays2, RemOutput),!.

mergeTAs([],_,X,X). /*merges all tas free schedules*/
mergeTAs([TA|RemTAs], TeachingSchedule, AccumulatedSchedule, FreeSchedule):-
taFreeWeek(TA, TeachingSchedule, TAFree),
mergeTwoWeeks(AccumulatedSchedule, TAFree, NewAcc),
mergeTAs(RemTAs, TeachingSchedule, NewAcc, FreeSchedule),!.

permuteSlots([],[]).
permuteSlots([day(DayName, [T1,T2,T3,T4,T5])|FreeDays],[day(DayName, [X1,X2,X3,X4,X5])|RemPermDays]):-
permutation(T1,X1),permutation(T2,X2),permutation(T3,X3),permutation(T4,X4),permutation(T5,X5),
permuteSlots(FreeDays, RemPermDays).

assign_quizzes([],_, []).
assign_quizzes([quiz(Course, Day, Slot, Count)|RemQuizzes],FreeSchedule, [proctors(quiz(Course, Day,Slot,Count), TA_List)|RemProctorSched]):-
assign_quiz(quiz(Course, Day, Slot, Count), FreeSchedule, TA_List),
assign_quizzes(RemQuizzes, FreeSchedule, RemProctorSched).

assign_quiz(quiz(_, Day, Slot, Count), FreeSchedule, _):-
day(Day,FreeSchedule, DaySlots),
free(Slot,DaySlots,FreeTAs),
length(FreeTAs, FreeCount),
FreeCount<Count,fail.

assign_quiz(quiz(_, Day, Slot, Count), FreeSchedule, AssignedTAs):-
day(Day,FreeSchedule, DaySlots),
free(Slot,DaySlots,FreeTAs),
length(FreeTAs, FreeCount),
pickSome(FreeTAs, Count, AssignedTAs),
FreeCount>=Count.

pickSome(List, N, Res):-
pickSomeHelp(List, N, [], Res).

pickSomeHelp(_, 0, X, X).
pickSomeHelp(List, N, Acc, Res):-
N > 0,
N1 is N -1,
member(X, List),
\+ member(X, Acc),
append(Acc, [X], AccNew),
pickSomeHelp(List, N1, AccNew, Res).

day(sat, [day(_,Slots)|_], Slots).
day(sun, [_,day(_,Slots) |_], Slots).
day(mon, [_,_,day(_,Slots)|_], Slots).
day(tue, [_,_,_,day(_,Slots)|_], Slots).
day(wed, [_,_,_,_,day(_,Slots)|_], Slots).
day(thu, [_,_,_,_,_,day(_,Slots) |_], Slots).

free(1, [S1,_,_,_,_], S1).
free(2, [_,S2,_,_,_], S2).
free(3, [_,_,S3,_,_], S3).
free(4, [_,_,_,S4,_], S4).
free(5, [_,_,_,_,S5], S5).