## Overview
PrinCut-auto is a tool providing both unsupervised automatic 3D cell detection and manual annotation assistance. 

The automatic 3D cell detection is based on multi-scale PRINcipal Curvature and min-CUT optimization. This detector is robust to noise and sensitive to inter-cellular gaps, achieving remarkable cell detection accuracy across various scenarios.

The manual annotation assistance is used to refine the detection result or generate more training datasets for supervised models. Users can merely click the cell to add, delete, split, or merge 3D cell labels.

A GPU is required for faster feature calculation. A standalone GUI is provided, but to use the code for a more flexible analysis, MATLAB 2023a or a later version is required.



<p align="center">
 <img src="./figure/GUI.png" width="70%">
</p>

## GUI Usage
**Automatic 3D cell detection**: 

Disable the "GPU visualization" option if your computer has limited GPU memory (> Pixel number * 4 * 10^-8 GB memory required).  Save your data in tif format data and click the *load data* button to read it. After loading the data, Adjust the *min intensity* and *max intensity* to adjust the contrast of the data. Select the figure and use the scroll wheel to zoom in and out, drag the figure to move in x and y directions, and use the bar at the bottom of the figure to move along z direction.

[Optional] Click the *get background* and select a rough background by global thresholding. The selected background will shown in green in GUI. The method is based on null hypothesis testing, enough background pixels without intensity truncation or saturation can significantly improve its accuracy.

Adjust the *x/z resolution*. For example, if your x resolution is 1 um/pixel while z resolution is 5 um/pixel, then *x/z resolution* should be 5. The *min smooth factor* and *max smooth factor* are the STD of the Gaussian smooth filter by pixel. Let the *min smooth factor* be about half of your smallest inter-cellular gap size and the *max smooth factor* be about half of your smallest cell size. Increasing the *z score threshold* value can detect fewer inter-cellular gaps and decrease the over-segmentation rate, and vice versa. Click the *segmentation* button and wait for the lamp at the right bottom corner to turn back to green.

<p align="center">
 <img src="./figure/GUIworkflow2.png" width="100%">
</p>

**Manual annotation assistance**:

Add, delete, split, or merge 3D cells by clicking:

https://github.com/yu-lab-vt/PrinCut-Auto/assets/45985407/4b5b38e8-0ed2-4494-a5df-c744179cb331


Keyboard short cut is available for convenience: *F* for *add a cell*, *D* for *delete a cell*, *V* for *split a cell*, *C* for *Merge two cells*, *W* for enable/disable overlay, *Q* and *E* for move along z-axis, *T* for randomly changing color for all labels.



