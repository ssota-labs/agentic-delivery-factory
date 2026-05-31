CREATE TABLE (
  "노드" TITLE,
  "키" RICH_TEXT,
  "요약" RICH_TEXT,
  "상태" SELECT('Draft':gray, 'Active':green, 'Deprecated':gray, 'Archived':brown),
  "카테고리" SELECT('Agreement':green, 'Product':blue, 'UX/UI':purple, 'Design System':pink, 'Engineering':orange, 'QA':yellow, 'Ops':brown, 'Handoff':gray),
  "범위" SELECT('Meta':purple, 'Instance':blue, 'Shared':green),
  "저장소 경로" RICH_TEXT,
  "출처 URL" URL,
  "외부 URL" URL,
  "담당자" PEOPLE,
  "정합성 확인됨" CHECKBOX,
  "정합성 상태" SELECT('미확인':gray, '정상':green, '주의':yellow, '깨짐':red),
  "마지막 정합성 확인일" DATE,
  "정합성 메모" RICH_TEXT
)
