God::Contacts::Email.defaults do |d|
  d.from_email = 'support@estormtech.com'
  d.from_name = 'God Notificaition'
  d.delivery_method = :sendmail
end

God.contact(:email) do |c|
  c.name = 'scott'
  c.group = 'developers'
  c.to_email = 'scott.sproule@gmail.com'
end

