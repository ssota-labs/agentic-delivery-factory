CREATE TABLE (
  "Name" TITLE,
  "태그" MULTI_SELECT(
    '제품 로드맵':purple,
    '정책':brown,
    'PRD':blue,
    '설계':yellow,
    '스펙':green,
    '릴리즈 노트':gray,
    'ADR':red,
    '가이드':blue,
    '리서치':pink,
    '정합성':orange
  ),
  "상태" SELECT('초안':gray, '리뷰중':yellow, '확정':green, '폐기':red)
)
