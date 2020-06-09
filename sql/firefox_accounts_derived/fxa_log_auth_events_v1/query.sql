SELECT
  jsonPayload.fields.event,
  jsonPayload.fields.user_id,
  jsonPayload.fields.flow_id,
  jsonPayload.fields.entrypoint,
  jsonPayload.fields.device_id,
  jsonPayload.fields.service,
  timestamp,
  jsonPayload.fields.useragent,
  jsonPayload.fields.os_version,
  jsonPayload.fields.utm_source,
  jsonPayload.fields.utm_campaign,
  jsonPayload.fields.utm_content,
  jsonPayload.fields.utm_medium,
  jsonPayload.fields.utm_term
FROM
  `moz-fx-fxa-prod-0712.fxa_prod_logs.docker_fxa_auth_20*`
WHERE
  NOT (
    REGEXP_CONTAINS(jsonPayload.fields.event, r"^email\.(\w+)\.bounced$")
    OR REGEXP_CONTAINS(jsonPayload.fields.event, r"^email\.(\w+)\.sent$")
    OR REGEXP_CONTAINS(jsonPayload.fields.event, r"^flow\.complete\.(\w+)$")
  )
  AND jsonPayload.fields.event NOT IN (
    'account.confirmed',
    'account.login',
    'account.login.blocked',
    'account.login.confirmedUnblockCode',
    'account.reset',
    'account.signed',
    'account.created',
    'account.verified',
    'sms.installFirefox.sent'
  )
  AND _TABLE_SUFFIX = FORMAT_DATE('%g%m%d', @submission_date)