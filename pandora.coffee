http = require 'http'
crypto = require 'crypto'
util = require 'util'
libpianocrypt = require './lib/pianocrypt/pianocrypt'
pianorpc = require './lib/pianorpc/pianorpc'

PROTOCOL_VERSION = '29'
PANDORA_URL = 'www.pandora.com'
API_URL = '/radio/xmlrpc/v' + PROTOCOL_VERSION + '?'
USER_AGENT = 'Pithos/0.2'

xmlrpc_call = (method, args, url_args) ->
  if url_args is true
    url_args = args
  args.splice 0, 0, new Date().getTime()
  xml = pianorpc.xmlrpc_make_call method, args
  data = libpianocrypt.PianoEncryptString xml
  console.log xml
  console.log data
  urimethod = method.split('.')[1]
  url_arg_strings = []
  url_arg_strings.push("method=#{urimethod}")
  console.log url_args
  count = 1
  for i in url_args
    console.log i
    url_arg_strings.push("arg#{count}=#{i}")
    count += 1
  url = API_URL + url_arg_strings.join('&')

  pandora = http.createClient 80, PANDORA_URL
  request = pandora.request 'POST', url, { 'user-agent': USER_AGENT, 'content-type': 'text/xml', 'content-length': "'#{data.length}'" }
  request.write(data)
  request.end()

  console.log "posting to #{PANDORA_URL + url}"
  request.on 'response', (resp) ->
    resp.setEncoding('utf8')
    console.log 'RESP: ' + util.inspect resp 
    resp.on 'data', (chunk) ->
      console.log 'BODY:' + chunk

connect = (user, password) ->
  user = xmlrpc_call('listener.authenticateListener', [user, password], [])

connect('dekz', 'test')

format_url_arg = (value) ->
  type = typeof value
  console.log type
  if type is 'boolean'
    if value is true
      return 'true'
    else 
      return 'false'
  else if type is 'string'
    return "'#{value}'" 
  else
    return value.join("%2C")


# pandora = http.createClient 80, PANDORA_URL

# request = pandora.request 'GET', '/', {'host': 'www.pandora.com', 'user-agent': USER_AGENT, 'content-type': 'text/xml'}

# request.end()
# request.on 'response', (resp) ->
#   console.log 'STATUS: ', resp.statusCode
#   console.log 'HEADERS: ', JSON.stringify resp.headers

#   resp.setEncoding 'utf8'
#   resp.on 'data', (chunk) ->
#     console.log 'BODY: ' + chunk
