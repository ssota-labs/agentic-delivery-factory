CREATE TABLE (
  "관계" TITLE,
  "관계 종류" SELECT('defines':blue, 'depends_on':orange, 'implements':green, 'validates':purple, 'supersedes':red, 'references':gray, 'blocks':red, 'produces':yellow),
  "상태" SELECT('Draft':gray, 'Active':green, 'Deprecated':gray, 'Archived':brown),
  "메모" RICH_TEXT
)
