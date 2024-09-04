import 'package:dog/src/config/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:table_calendar/table_calendar.dart';

class PostingCalendar extends StatefulWidget {
  final Function(DateTime) onDateSelected;

  const PostingCalendar({
    super.key,
    required this.onDateSelected,
  });

  @override
  State<PostingCalendar> createState() => _PostingCalendarState();
}

class _PostingCalendarState extends State<PostingCalendar> {
  DateTime _focusedDay = DateTime.now();
  late DateTime _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(14.w, 20.h, 14.w, 9.h),
      child: Container(
        padding: EdgeInsets.fromLTRB(30.w, 24.h, 30.w, 24.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Palette.green6,
            width: 1.0,
          ),
        ),
        child: Stack(
          children: [
            TableCalendar(
              focusedDay: _focusedDay,
              firstDay: DateTime(_focusedDay.year, _focusedDay.month),
              lastDay: DateTime(_focusedDay.year, _focusedDay.month + 3),
              availableGestures: AvailableGestures.none,
              daysOfWeekHeight: 20.h,
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                leftChevronVisible: false,
                rightChevronVisible: false,
                titleCentered: false,
                headerPadding: EdgeInsets.only(bottom: 14.h),
                titleTextFormatter: (DateTime date, dynamic locale) {
                  return '${date.year}년 ${date.month}월';
                },
                titleTextStyle: TextStyle(
                  color: Palette.darkFont4,
                  fontSize: 13.sp,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w600,
                ),
              ),
              calendarStyle: const CalendarStyle(
                isTodayHighlighted: false,
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: TextStyle(
                  color: const Color(0xFF212121),
                  fontSize: 13.sp,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w600,
                ),
                weekendStyle: TextStyle(
                  color: Colors.blue,
                  fontSize: 13.sp,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w600,
                ),
              ),
              // selectedDayPredicate: (day) {
              //   return isSameDay(_selectedDay, day);
              // },
              calendarBuilders: CalendarBuilders(
                // 요일 텍스트 스타일을 설정하는 부분
                dowBuilder: (context, day) {
                  final text = ['월', '화', '수', '목', '금', '토', '일'][day.weekday - 1];
                  final style = TextStyle(
                    color: /*day.weekday == DateTime.saturday
                        ? Colors.blue
                        : day.weekday == DateTime.sunday
                        ? Colors.red
                        : Colors.black,*/
                    Palette.darkFont4,
                    fontSize: 13.sp,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w600,
                  );
                  return Center(
                    child: Text(text, style: style),
                  );
                },
                // 날짜 텍스트 스타일을 설정하는 부분
                defaultBuilder: (context, date, _) {
                  if (date.isBefore(DateTime.now().add(const Duration(days: -0)))) {
                    // 이전 날짜인 경우 선택할 수 없도록 비활성화 처리합니다.
                    return Center(
                      child: Text(
                        '${date.day}',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 13.sp,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    );
                  } else {
                    // 이후 날짜인 경우 선택 가능하도록 처리합니다.
                    if (date.month == _focusedDay.month) {
                      // if (date.weekday == DateTime.saturday) {
                      //   return Center(
                      //     child: Text(
                      //       '${date.day}',
                      //       style: const TextStyle(
                      //         color: Colors.blue,
                      //         fontSize: 13.11,
                      //         fontFamily: 'Pretendard',
                      //         fontWeight: FontWeight.w700,
                      //       ),
                      //     ),
                      //   );
                      // } else if (date.weekday == DateTime.sunday) {
                      //   return Center(
                      //     child: Text(
                      //       '${date.day}',
                      //       style: const TextStyle(
                      //         color: Colors.red,
                      //         fontSize: 13.11,
                      //         fontFamily: 'Pretendard',
                      //         fontWeight: FontWeight.w700,
                      //       ),
                      //     ),
                      //   );
                      // }
                      return Center(
                        child: Text(
                          '${date.day}',
                          style: TextStyle(
                            color: const Color(0xFF4C433F),
                            fontSize: 13.sp,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      );
                    } else {
                      // 다음 달 또는 이전 달의 날짜에 대한 처리는 이전과 동일하게 유지합니다.
                      return Center(
                        child: Text(
                          '${date.day}',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 13.sp,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      );
                    }
                  }
                },
                // 선택된 날짜에 대한 동그라미 표시를 설정합니다.
                selectedBuilder: (context, date, _) {
                  if (date.isBefore(DateTime.now().add(const Duration(days: -1)))) {
                    return Center(
                      child: Container(
                        width: 39.33.w,
                        height: 39.33.h,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.transparent, // 투명한 색상으로 설정하여 마커를 숨깁니다.
                        ),
                        child: Center(
                          child: Text(
                            '${date.day}',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 13.sp,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Center(
                      child: Container(
                        width: 39.w,
                        height: 39.h,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Palette.green6,
                        ),
                        child: Center(
                          child: Text(
                            '${date.day}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13.sp,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });

                widget.onDateSelected(selectedDay);
              },
            ),
            Positioned(
              right: 0,
              top: -15,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(Icons.chevron_left, size: 30.w),
                    onPressed: () {
                      // 왼쪽 화살표 클릭 시 동작
                      setState(() {
                        if (_focusedDay.month == DateTime.now().month && _focusedDay.year == DateTime.now().year) {
                          _focusedDay = DateTime.now();
                        } else {
                          _focusedDay = DateTime(_focusedDay.year, _focusedDay.month - 1);
                        }
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.chevron_right, size: 30.w),
                    onPressed: () {
                      // 오른쪽 화살표 클릭 시 동작
                      setState(() {
                        if (_focusedDay.month < DateTime.now().month + 3 && _focusedDay.year <= DateTime.now().year) {
                          _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + 1);
                        } else if (_focusedDay.year > DateTime.now().year && _focusedDay.month < 2 - (12 - DateTime.now().month)) {
                          _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + 1);
                        } else {
                          _focusedDay = _focusedDay;
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
