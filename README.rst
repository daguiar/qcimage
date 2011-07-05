QC-IMAGE NOTES
--------------

Research Needed
---------------

- Investigate the diff sotrage overhead for Brink/Steam DRM. Steam DRM
  uses custom binaries per user... We need to understand the
  percentage of changed data as found by git's binary diff algorithm.

Goals
-----

Don't expose Linux

     Linux *may* be required, but it's confusing to players. Linux mode
     should not be interactive

Don't rely on netboot 

     NICs are often shitty, if at all possible boot local OS for
     routine operations. This doesn't include one time operations
     (e.g. clonezilla)

Make it pretty

     Players will respect the system more if it is polished. Consider
     soliciting artwork (id collab) for splash screens.

Make sure it gets used

     Get the capability list to tourney early so they plan for machine
     grouping. Write documentation so they know how to use it.
    

Files
=====

/windows

     Hierarchy that lives on the windows partition onthe Hard Drive

/scripts

     Scripts to be run from the Linux USB environment

