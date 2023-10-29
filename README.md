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

## What is the psttl format?

You might be asking what are those psttl files? If you
open them (they are in plain text) you might see a familiar
pattern if you know Linked (Open) Data. The format is a
"pseudo Turtle" subject-predicate-object triple format.
Turtle is one of the data formats for RDF (W3C's Resource
Description Format standard).

In short, this format is a very readable but also processable
format where you almost write a kind of poetry to build a
knowledge graph, to create a nice overview on your topic and
to document insights that are easily written down, while
quickly recalled, for maximum mental accessibility.

If you paste the psttl contents into https://kennisgraaf.app
it will generate from it a knowledge graph diagram you can
navigate (entirely client-side, source code is at
https://github.com/robvandenbogaard/kennisgraaf).
