// Drew inspiration from here.
// https://ethereum.stackexchange.com/questions/48627/how-to-catch-revert-error-in-truffle-test-javascript
//
const PREFIX = 'VM Exception while processing transaction: '

const errTypes = {
  revert: 'revert',
  outOfGas: 'out of gas',
  invalidJump: 'invalid JUMP',
  invalidOpcode: 'invalid opcode',
  stackOverflow: 'stack overflow',
  stackUnderflow: 'stack underflow',
  staticStateChange: 'static state change'
}

const tryCatch = async (promise, errType, message) => {
  try {
    await promise
    throw new Error(message)
  } catch (error) {
    console.log(error.message)
    // todo: file issue with ganache-cli
    //
    // expect:   error.message to be PREFIX + revert
    // observed: error.message to be something else
    // msg @chris_smith when issue is created
    if (errType === 'revert') {
      assert(error.toString().includes('revert'), 'Expected a `revert`')
    } else {
      assert(
        error.message.startsWith(PREFIX + errType),
        "Expected an error starting with '" + PREFIX + errType
      )
    }
  }
}

module.exports = {
  errTypes,
  tryCatch
}
