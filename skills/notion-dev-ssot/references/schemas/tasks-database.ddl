CREATE TABLE (
  "Task" TITLE,
  "Task ID" RICH_TEXT COMMENT 'Stable task id e.g. PREFIX-P1.0-PRD',
  "상태" STATUS('대기':gray, '진행중':blue, '보류':orange, '완료':green, '취소':red),
  "작업 유형" SELECT(
    '상세 로드맵 작성':purple,
    'PRD 작성':blue,
    '설계 작성':yellow,
    '구현':green,
    '검증':pink
  ),
  "종속성" RICH_TEXT COMMENT 'Predecessor milestones or doc names'
)
