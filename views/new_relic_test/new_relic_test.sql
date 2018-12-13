-- Data: 01/01/16-06/30/17
select
  id::integer
  , score::integer
  , promoter_status::varchar
  , promoter_count::integer
  , passive_count::integer
  , detractor_count::integer
  , nps_comment::varchar
  , email::varchar
  , response_date::date
  , survey_source_url::varchar
  , rpm_id::varchar
  , city
  , state
  , country
  , total_spend
  , company_size::varchar
  , [cosize_to_salessegment(company_size)] sales_segment
  , agent_language::varchar
  , apm_product::varchar
  , mobile_product::varchar
  , browser_product::varchar
  , insights_product::varchar
  , synthetics_product::varchar
  , primary_theme::varchar
  , secondary_theme::varchar
  , tertiary_theme::varchar
  , [nps_tickers(nps_fy16q4_to_fy18q1)]
from
  [nps_fy16q4_to_fy18q1]
union all
-- Data: 07/01/17-06/30/18
select
  *
from
  (
    [nps_base]
  )
  -- Data: 07/01/18-08/11/18
union all
(
  [nps_rawprep(wootric_responses_2018_07_01)]
)
union all
(
[nps_rawprep(wootric_responses_2018_08_12)]
)
union all
(
[nps_rawprep(wootric_responses_2018_08_19)]
)
union all
(
[nps_rawprep(wootric_responses_2018_08_26)]
)
union all
(
[nps_rawprep(wootric_responses_2018_09_02)]
)
union all
(
[nps_rawprep(wootric_responses_2018_09_09)]
)
union all
(
[nps_rawprep(wootric_responses_2018_09_16)]
)
union all
(
[nps_rawprep(wootric_responses_2018_09_30)]
)
union all
(
[nps_rawprep(wootric_responses_2018_10_07)]
)
union all
(
[nps_rawprep(wootric_responses_2018_10_14)]
)
union all
(
[nps_rawprep(wootric_responses_2018_10_21)]
)
union all
(
[nps_rawprep(wootric_responses_2018_10_28)]
)
union all
(
[nps_rawprep(wootric_responses_2018_11_11)]
)
union all
(
[nps_rawprep(wootric_responses_2018_11_18)]
)
union all
(
[nps_rawprep(wootric_responses_2018_12_02)]
)