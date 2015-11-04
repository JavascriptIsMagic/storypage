policy = require '../policy.coffee'

class AccountsController extends require '../controller.coffee'
  namespace: '/accounts'
  '/get': ->
    @body = policy
