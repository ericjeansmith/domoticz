local _  = require('lodash')
local utils = require('Utils')

local function HTTPResponce(domoticz, responseData)

	local self = {}
	 
	self.headers = responseData.headers or {}
	self.baseType = domoticz.BASETYPE_HTTP_RESPONSE
	self.data = responseData.data or nil

	self.statusCode = _.get(responseData, {'statusCode'}, 0)
	self._contentType = _.get(self.headers, {'Content-Type'}, '')

	self.isJSON = false

	if self.headers.status then
		self.statusCode = tonumber((self.headers.status):match("%s+(%S+)"))
	end

	self.ok = false
	if (self.statusCode >= 200 and self.statusCode <= 299) then
		self.ok = true
	end

	self.isHTTPResponse = true
	self.isDevice = false
	self.isScene = false
	self.isGroup = false
	self.isTimer = false
	self.isVariable = false
	self.isSecurity = false

	self.callback = responseData.callback
	self.trigger = responseData.callback

	if (string.match(self._contentType, 'application/json') and self.data) then
		local json = utils.fromJSON(self.data)

		if (json) then
			self.isJSON = true
			self.json = json
		end
	end

	utils.log('HTTPResponse: headers = ' .. _.str(self.headers), utils.LOG_DEBUG)

	return self
end

return HTTPResponce
