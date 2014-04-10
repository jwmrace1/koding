{ Model, signature, secure } = require 'bongo'

module.exports = class JKiteStack extends Model

  @share()

  @set
    sharedMethods :
      static      :
        fetchInfo : (signature Function)
        setInfo   : (signature Object, Function)
    schema        :
      ratio       : Number
      isEnabled   : Boolean

  @fetchInfo = (callback) -> @one {}, callback

  @setInfo = secure (client, { ratio, isEnabled }, callback) ->
    { connection:{ delegate }} = client

    if delegate.can 'flag'
      modifier = $set: {}

      modifier.$set.ratio       = ratio       if ratio?
      modifier.$set.isEnabled   = isEnabled   if isEnabled?

      @getCollection().update {}, modifier, upsert: yes, (err) -> callback err
    else
      callback message: "Access denied!"
