case
  when [nps_comment_table].nps_comment ~ '[a-zA-Z]+'
    then 1
  else null
end has_comment
, case
  when (primary_theme = 'Price/Value' or primary_theme = 'PRICE/VALUE')
    then 1
  else null
end is_price_value
, case
  when (primary_theme = 'CX' or primary_theme = 'CX')
    then 1
  else null
end is_cx
, case
  when (primary_theme = 'UX' or primary_theme = 'UX')
    then 1
  else null
end is_ux
, case
  when (primary_theme = 'Functionality' or primary_theme = 'FUNCTIONALITY')
    then 1
  else null
end is_functionality
, case
  when (primary_theme = 'NPS Survey' or primary_theme = 'NPS-SURVEY')
    then 1
  else null
end is_nps