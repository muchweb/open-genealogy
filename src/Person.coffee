'use strict'

require 'ember/runtime'
require 'ember/rsvp'
q = require 'q'

Name = require './Name.js'

module.exports = Ember.Object.extend

	names: []

	FromDatabase: (data) ->
		deferred = q.defer()
		setImmediate =>

			database.name.find
				$or: data.names.map (id) ->
					_id: id
			, (error, items) =>
				(q.all items.map (item) =>
					inner = q.defer()
					setImmediate =>
						((new Name).FromDatabase item).then (name) =>
							@names.push name
							inner.resolve()
					inner.promise
				).then =>
					deferred.resolve @

		deferred.promise
