xmlrpc_value = (value) ->
  switch (typeof value)
    when 'string'
      return "<value><string>#{value}</string></value>"
    when 'number'
      return "<value><int>#{value}</int></value>"
    when 'boolean'
      if value
        return '<value><boolean>1</boolean></value>'
      else
        return '<value><boolean>0</boolean></value>'
    else
      if value[0]?
        argList = []
        for v in value
          argList.push xmlrpc_value(v)
        prep = '<value><array><data>'
        mid = argList.join ''
        end = '</data></array></value>'
        return prep+mid+end

module.exports.xmlrpc_make_call = xmlrpc_make_call = (method, args) ->
  xmlArgs = []
  for a in args
    val = xmlrpc_value(a)
    xmlArgs.push("<param>#{val}</param>")
  return "<?xml version=\"1.0\"?><methodCall><methodName>#{method}</methodName><params>#{xmlArgs.join('')}</params></methodCall>"

module.exports.xmlrpc_parse = xmlrpc_parse = (tree) ->
  console.log "parsing #{tree}"
