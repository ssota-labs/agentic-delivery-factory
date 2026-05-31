CREATE TABLE (
  "작업" TITLE,
  "작업 ID" RICH_TEXT COMMENT 'Stable task id, e.g. {{TASK_PREFIX}}-PLAT-001-IMPL',
  "상태" SELECT('대기':gray, '진행중':blue, '보류':orange, '완료':green, '취소':red),
  "작업 유형" SELECT('공장 설계':purple, '스킬 작성':blue, '노드 문서 작성':green, '엣지 생성':yellow, '정합성 체크':orange, '구현':pink, '검증':brown, 'GTM':red),
  "트랙" SELECT('Platform':blue, 'GTM':green, 'Ops':orange),
  "우선순위" SELECT('High':red, 'Medium':yellow, 'Low':gray),
  "범위" SELECT('Meta':purple, 'Instance':blue, 'Shared':green),
  "요약" RICH_TEXT,
  "종속성" RICH_TEXT,
  "저장소 경로" RICH_TEXT,
  "진행일" DATE COMMENT 'Work start timestamp; set date:진행일:is_datetime=1 with ISO-8601 datetime when starting work',
  "마감일" DATE COMMENT 'Target completion date; typically date-only (date:마감일:is_datetime=0)',
  "목표" RELATION('GOALS_DS_ID', DUAL '작업' 'tasks')
)

-- Default project-page timeline view:
-- TIMELINE BY "진행일" TO "마감일"
