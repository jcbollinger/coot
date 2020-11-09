---
layout: post
title:  "Coot Cryo-EM Tutorial 2: Fitting and Mutating"
date: Tue 20 Oct 16:53:52 BST 2020
---

<div style="text-align: right"> By Ana Casa&ntilde;al &amp; Paul Emsley</div>
This tutorial is designed for 0.9.1

Aim: we will fit a domain of the Cleavage and Polyadenylation Factor

1: Setting Up
-------------

### 1.1 Fetch the Files

Using a web browser, download the bundle for EMD-3908

  - [http://www.ebi.ac.uk/pdbe/entry/emdb/EMD-3908](http://www.ebi.ac.uk/pdbe/entry/emdb/EMD-3908)

Move that tar file here and extract it.

Let's download the sequence of a fragment of the structure:

  - [https://www2.mrc-lmb.cam.ac.uk/personal/pemsley/coot/files/CPF-X-domain.seq](https://www2.mrc-lmb.cam.ac.uk/personal/pemsley/coot/files/CPF-X-domain.seq)

Move that sequence file to the current directory (for easy access).

Start _Coot_:

`$ coot --map EMD-3908/map/emd_3908.map`

### 1.2 Map Manipulation

Let's see more of the map

  - **Edit** &rarr; **Map Parameters** &rarr; **Map Radius EM** &rarr; `70`
  - **OK**

Let's use a smoother map

   - **Cryo-EM** &rarr; **Sharpen/Blur...**
   - activate the "Resample" checkbutton
   - **Make Map**
   - **Close**

You should now have an extra map ("emd_3908.map Blur 20.00").
Compare this maps with the original and then delete the 1st (mrc) map. You should find that the
new (smooth) map is easier to understand.

Choose the Blur\_200.0 map for fitting (at the moment):

  - **Map** &rarr; {Select the Blur\_200.0} &rarr; **OK**

Change the contour Step for the new Maps:

**Display Manager** &rarr; **Properties** &rarr; **Change by rmsd** `0.33` &rarr; **OK**

As a rule of thumb, a good contour level is 5.5 rmsd.

### 1.3 Get the Homolog:

  - **File** &rarr; **Fetch Model using Accession Code...** `6f9n`

Move back to the middle of the molecule map

  - **Cryo-EM** &rarr; **Go To Map Molecule Middle**

  - Now move the homolog to the centre of the map:
  - **Calculate** &rarr; **Move Molecule Here**
  - Choose the "6f9n" molecule
  - **Move It**

2: Jiggle
---------

  - **Morph** &rarr; **Jiggle Fit This Molecule with Fourier Filter** 

It should roughly fit now. If it doesn't, try jiggling again once or twice more. In this case,
you should be looking for a fit score of over 1000.


3: Extract Our Fragment
-----------------------

Extract the worst-fitting (WD40) domain:

  - Using **Jones' Rainbow**, find the domain start and end residues numbers (you are trying to find a
    doughnut-shaped molecule that fits this doughnut-shaped density)
  - Let's imagine that you think that the residues at the ends of the domain are 517 and 1011:
  - **Edit** &rarr; **Copy Fragment** &rarr; [Use Atom Selection:] `//A/517-1011` &rarr; **OK**

Let's work on this fragment:

  - **Display Manager** &rarr; **Last Only**

Let's delete the sidechains from the atom selection molecule (number 4 usually):

  - **Calculate** &rarr; **Modelling** &rarr; **Delete Side-chains for Active Chain**

For the most recent model, use

  - **C-alphas/Backbone + Ligands**
  - **OK** [Dismiss the Display Manager]


4: Setup Refinement
-------------------

We need to adjust the weighting of the map to the model:

  - **R/RC** &rarr; **Estimate** &rarr; **OK**

Let's add some local distance restraints:

  - **Calculate** &rarr; **Modules** &rarr; **Restraints**

    Usually 5.0 works well for models with no sidechains
  - **Restaints** &rarr; **Generate All Molecule Self Restraints 5.0**
  - Review them, then undisplay them:
  - **Restaints** &rarr; **Undisplay Extra Distance Restraints**
  - **Refine** &rarr; **Set Geman-McClure alpha 0.01**


5: Refinement
-------------

  - **Refine** &rarr; **Chain Refine**
  - {wait and watch, you can turn the view if you wish}

When the refinement dialog says "Success," examine the model, being careful not to inadvertently
pull on an atom. Maybe you will see that there is a domain that doesn't fit, if so, yank
on the worst fitting CA and pull it to where you think it should go.

   - Double-clicking on an atom will release the pull restraint

When you are happy, dismiss the Refinement dialog:

  - OK

### 5.1 Redo

It can be non-trivial to decide what needs to move and how to move it. It is worth undoing your
modifications and refining again for practice.

This time perhaps without drawing the restraints:

  - Undo
  - `set_draw_moving_atoms_restraints(0)`
  - **Refine** &rarr; **Chain Refine**
  - _yank as needed_
  - **OK**

... or with different cut-off for the Geman-McClure restraints, or a different alpha for the Geman-McClure restraints, or a different weight for the map. Or a different blur for the map. You can delete the current extra restraints with **Restraints** &rarr; **Delete All Extra Restraints**.

  - Try proportial editing: with the Real Space Refinement active, use Ctrl Middle-mouse scroll
    to change the radius of the atoms affected by the atom pull displacement.

  - Test, play, refine, yank until satisfied.

Reset Geman-McClure alpha to 1.


6: Review and Trim
------------------

Upon review, you will notice that there are parts of the model that
don't fit the map. Try yanking them around with Tandem Refine. Other
parts of the model don't have density - so delete the residue range - this may help the alignment we are about to do.

Maybe the density fit validation dialog will be useful? You will need
to reset the weight: `0.3` seems like a good number

  - **Validate** &rarr; **Density Fit Analysis**


7: Mutate
-----------

  - **Calculate &rarr; Use ClustalW for Alignment, Then Mutate**
    
    The chain for mutatation is the A chain the target sequence is in the file `CPF-X-domain.seq`
  - _{wait}_
  - **Refine** &rarr; **Chain Refine**
  - **OK**


8: Check & Edit
-------

Go through the structure residue by residue looking for things to fix

  - Out of register errors
  - Missing side-chains
  - Missing loops
  - Loops with too many residues in the model
  - Bad rotamers
  - Bad peptides
  - Clashes
  - Use: **Validate** &rarr; **Alignment vs. PIR...** to help you adjust the residue numbers

There will be places where you need to close (or open) a loop by renumbering residues.

  - Use **Validate &rarr; Validation Outliers**
    or
  - **Validate &rarr; Overlaps, Peptides, CBeta, Rama and Rota Outliers**
