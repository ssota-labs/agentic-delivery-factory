CREATE TABLE (
  "관계" TITLE,
  "관계 종류" SELECT('defines':blue, 'depends_on':orange, 'implements':green, 'validates':purple, 'supersedes':red, 'references':gray, 'blocks':red, 'produces':yellow),
  "상태" SELECT('Draft':gray, 'Active':green, 'Deprecated':gray, 'Archived':brown),
  "메모" RICH_TEXT,
  "정합성 확인됨" CHECKBOX,
  "정합성 상태" SELECT('미확인':gray, '정상':green, '주의':yellow, '깨짐':red),
  "마지막 정합성 확인일" DATE,
  "정합성 메모" RICH_TEXT
)
