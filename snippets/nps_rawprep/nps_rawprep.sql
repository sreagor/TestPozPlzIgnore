with
  base as (
    select
      [csv_name].id
      , score
      , [nps_promoter_status]
      , case
        when score between 9 and 10 then 1
        else null
      end promoter_count
      , case
        when score between 7 and 8 then 1
        else null
      end passive_count
      , case
        when score between 0 and 6 then 1
        else null
      end detractor_count
      , text nps_comment
      , email
      , raw_users.id user_id
      , response_date
      , survey_source_url
      , coalesce(split_part(survey_source_url,'/',5)::varchar, default_account_id::varchar) as rpm_id
      , company_size
      , agent_language
      , apm_product
      , mobile_product
      , browser_product
      , insights_product
      , synthetics_product
      , case
          when tags like '%P%'
            then regexp_substr(tags, '\"P\:([^"]*)',1,1,'e')
        end primary_theme
      , case
          when tags like '%P%'
            then regexp_substr(tags, '.*\"S\:([^"]*)',1,1,'e')
        end secondary_theme
      , case
          when tags like '%P%'
            then regexp_substr(tags, '.*\"T\:([^"]*)',1,1,'e')
        end tertiary_theme
    from [[csv_name]]
    left join src_rpm_accountsdb.raw_users using(email)
    )
, blank_rpm_ids as (
     select
       user_id::varchar
     from
       base
     where
       rpm_id !~ '[0-9]+'
      and user_id is not null
   )
, fill_in as (
    select
      user_id
      , account_id fav_account_id
    from
      ([product_users(user_id in (select distinct user_id from blank_rpm_ids) and received_at > current_date - interval '365 days')])
    where
        account_id is not null
  )
, base2 as (
  select
      id
      , score
      , promoter_status
      , promoter_count
      , passive_count
      , detractor_count
      , nps_comment
      , email
      , response_date
      , survey_source_url
      , coalesce(rpm_id::varchar,fav_account_id::varchar) rpm_id
      , agent_language
      , company_size
      , [cosize_to_salessegment(base.company_size)] sales_segment
      , [prod_sub_normalize(base.apm_product)] apm_product
      , [prod_sub_normalize(base.mobile_product)] mobile_product
      , [prod_sub_normalize(base.browser_product)] browser_product
      , [prod_sub_normalize(base.insights_product)] insights_product
      , [prod_sub_normalize(base.synthetics_product)] synthetics_product
      , primary_theme
      , secondary_theme
      , tertiary_theme
  from
    base
  left join fill_in using(user_id)
)
select
  base2.id::integer
  , base2.score::integer
  , base2.promoter_status::varchar
  , base2.promoter_count::integer
  , base2.passive_count::integer
  , base2.detractor_count::integer
  , base2.nps_comment::varchar
  , base2.email::varchar
  , base2.response_date::date
  , base2.survey_source_url::varchar
  , base2.rpm_id::varchar
  , coalesce(billing_city, location_city_name)::varchar city
  , coalesce(billing_state, location_region_name)::varchar state
  , coalesce(billing_country, location_country_name)::varchar country
  , total_arr::varchar total_spend
  , base2.company_size::varchar
  , base2.sales_segment::varchar
  , base2.agent_language::varchar
  , base2.apm_product::varchar
  , base2.mobile_product::varchar
  , base2.browser_product::varchar
  , base2.insights_product::varchar
  , base2.synthetics_product::varchar
  , primary_theme::varchar
  , secondary_theme::varchar
  , tertiary_theme::varchar
  , [nps_tickers(base2)]
from
  base2
left join dim_account_hierarchy on rpm_id=sub_account_id
left join ([payingcust_wip]) pc on effective_subscription_account_id=pc.account_id
left join sfdc.accounts c on sfdc_fam_id=c.id
left join (
  select
    email
    , location_city_name
    , location_region_name
    , location_country_name
    , updated_at
    , session_count
  from
    intercom.users
  left join (select email, max(updated_at) max_updated_at, max(session_count) max_session_count from intercom.users group by 1) using(email)
  where
    updated_at=max_updated_at
    and session_count=max_session_count
) using(email)