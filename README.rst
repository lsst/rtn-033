.. image:: https://img.shields.io/badge/rtn--033-lsst.io-brightgreen.svg
   :target: https://rtn-033.lsst.io
.. image:: https://github.com/lsst/rtn-033/workflows/CI/badge.svg
   :target: https://github.com/lsst/rtn-033/actions/

###########################
The In-Kind Helpdesk System
###########################

RTN-033
=======

We use Jira and the Jarvis auto-ticketer to implement an outward-facing Helpdesk system, with configuration and operating procedure designed for use by the Rubin LSST in-kind program contribution teams and recipients as they seek assistance from the In-kind Program Coordinators (IPC) in the Rubin operations IPC Team. 
The system follows an initial design by the Rubin construction project Communications  (COMT) and IT teams. 
This technote describes the system and its use.

Links
=====

- Live, commentable source: `RTN-033 Google doc <https://docs.google.com/document/d/1QTTl50l2FCMV1EvwvURCj5ui28eZTIW27EjO1etg4lM/edit>`_
- Live drafts: https://rtn-033.lsst.io
- GitHub: https://github.com/lsst/rtn-033

Build
=====

PDF is generated via a download from the Google doc source that is triggered by a pull request. 

Updating acronyms
-----------------

A table of the technote's acronyms and their definitions are maintained in the ``acronyms.tex`` file, which is committed as part of this repository.
To update the acronyms table in ``acronyms.tex``::

    make acronyms.tex

*Note: this command requires that this repository was cloned as a submodule.*

The acronyms discovery code scans the LaTeX source for probable acronyms.
You can ensure that certain strings aren't treated as acronyms by adding them to the `skipacronyms.txt <./skipacronyms.txt>`_ file.

The lsst-texmf_ repository centrally maintains definitions for LSST acronyms.
You can also add new acronym definitions, or override the definitions of acronyms, by editing the `myacronyms.txt <./myacronyms.txt>`_ file.

Needed acronyms then need to be added manually to the Google doc source.
