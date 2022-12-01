*&---------------------------------------------------------------------*
*& Report ZC2MMR2001
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zc2mmr2001_top                          .  " Global Data
INCLUDE ZC2MMR2001_s01                          .  " Screen
INCLUDE ZC2MMR2001_c01                          .  " Local
INCLUDE zc2mmr2001_o01                          .  " PBO-Modules
INCLUDE zc2mmr2001_i01                          .  " PAI-Modules
INCLUDE zc2mmr2001_f01                          .  " FORM-Routines

INITIALIZATION.
  titel = '오더 생성'.

AT SELECTION-SCREEN OUTPUT.

  PERFORM set_screen. "라디오 버튼 조작시


AT SELECTION-SCREEN ON VALUE-REQUEST FOR pa_vendo.        "벤더 서치헬프 축약
  PERFORM f4_ven.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR so_vend-low.     "벤더 서치헬프 축약
  PERFORM f4_ven2 USING 'LOW'.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR so_flag-low. "상태 플래그 서치헬프 축약
  PERFORM f4_flag USING 'LOW'.

AT SELECTION-SCREEN ON pa_vendo.
  PERFORM vaild_date_check.


START-OF-SELECTION.

  PERFORM get_jego_data.    "토탈 아이템 리스트 출력
  PERFORM set_input_screen. "첫 화면 Input창 데이터 출력.
  PERFORM set_edit_cell.    "특정 셀 입력잠금
*  PERFORM get_plan_data.    "구매 계획 가져오기.

  IF ra_vie = 'X'.

    PERFORM get_gume_data.  "승인대기 페이지 데이터 불러오기.
    CALL SCREEN '0101'.

  ELSEIF ra_vie2 = 'X'.
    PERFORM get_gume_data3. "승인완료 페이지 데이터 불러오기.
    CALL SCREEN '0103'.
  ELSE.
    IF pa_vendo IS INITIAL.
      MESSAGE s005 WITH '거래처를 입력해주세요' DISPLAY LIKE 'E'.
      LEAVE LIST-PROCESSING.
    ENDIF.


    CALL SCREEN '0100'.     "오더생성 페이지 불러오기.
  ENDIF.