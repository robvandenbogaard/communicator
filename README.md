# Communicator

Our own Matrix chat client!

The UI is in Dutch for now, because we develop local-first
to keep development closer to the early-adopter end-users
(but we are open to global collaboration so feel welcome
to join and push us to make it multi-lingual ;)).

## Dependencies

- The Elm compiler and reactor: https://guide.elm-lang.org
- Noordstar's Matrix SDK: https://github.com/noordstar/elm-matrix-sdk

## Trying it out

Install Elm (it is a single binary, containing everything
you need to develop, besides a text editor).

Clone the Communicator repository (this one) into its own
directory, and clone the Matrix SDK repository (see above)
into a directory next to it; the communicator code expects
its Elm source code to be at ../elm-matrix-sdk/src (as
seen from the root directory of the communicator).

Go into the root directory of the communicator.

Execute "elm reactor" in the command console, and see its
output for directions where to point your internet browser
to to see the app.
