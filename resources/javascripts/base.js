// Generated by CoffeeScript 1.3.1
(function() {
  var Message, exports;

  exports = window;

  Message = (function() {

    Message.name = 'Message';

    function Message(address) {
      this.address = address;
      this.values = [];
    }

    Message.prototype.addString = function(v) {
      return this.values.push({
        type: 'string',
        value: v
      });
    };

    Message.prototype.addInt = function(v) {
      return this.values.push({
        type: 'int',
        value: v
      });
    };

    Message.prototype.addFloat = function(v) {
      return this.values.push({
        type: 'float',
        value: v
      });
    };

    Message.prototype.addBool = function(v) {
      return this.values.push({
        type: 'bool',
        value: v
      });
    };

    Message.prototype.addBlob = function(v) {
      return this.values.push({
        type: 'blob',
        value: v
      });
    };

    Message.prototype.addTimeTag = function(v) {
      return this.values.push({
        type: 'timetag',
        value: v
      });
    };

    Message.prototype.addImpulse = function() {
      return this.values.push({
        type: 'impulse',
        value: 1
      });
    };

    Message.prototype.addNull = function() {
      return this.values.push({
        type: 'null',
        value: null
      });
    };

    Message.prototype.serialize = function() {
      return encodeURIComponent(JSON.stringify(this.values));
    };

    Message.prototype.send = function() {
      return location.href = "taucher:/" + this.address + "/" + (this.serialize());
    };

    return Message;

  })();

  exports.Message = Message;

}).call(this);
