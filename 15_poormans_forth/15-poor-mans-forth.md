# [[#15] Poor Man's FORTH](http://www.puzzlenode.com/puzzles/15-poor-mans-forth)

_This puzzle was contributed by Jia Wu and Gregory Brown and published on November 15, 2011_

Eddie the Esoteric Programmer has enlisted your help in making a new stack based programming language. He claims it's going to be the next big thing, even if others keep telling him it pretty much looks like a poor man's [FORTH](http://en.wikipedia.org/wiki/FORTH). While you are fairly certain that Eddie is more crazy than brilliant, you are giving him the benefit of the doubt because he has promised to give you a lifetime supply of free [LOLCODE](http://en.wikipedia.org/wiki/Lolcode) consulting if you are successful in helping him.

Eddie has already sketched out a few example programs and even has a few unit tests describing how his language should work. He has given you the source code for both sample programs as well as the tests, but has only provided the expected output for one of the samples. He claims this is because he does not trust anyone except LOLCODE programmers, and wants some proof that you actually know what you are doing.

## Your Task

In order to gain Eddie's trust, you need to implement an interpreter for his language which supports all the features found in his _challenge.stack_ program. He claims that if you read the _stacker_test.rb_ file as well as the _sample.stack_ and _sample_output.txt_ file, you should have no trouble hacking together something that will meet his expectations.

Note that Eddie's unit tests include some features that aren't used by _challenge.stack_ at all. While Eddie would be thrilled if you built a more complete implementation of his language, you will sufficiently impress him by providing a text file that matches what he'd expect to see as the output of the _challenge.stack_ program.

Beyond giving you these files to work with, Eddie has not provided any additional details. He claims that this is for your own good, but refuses to elaborate further.