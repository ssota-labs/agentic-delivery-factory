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
  "담당자" PEOPLE
)
