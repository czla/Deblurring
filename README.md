#**Noblind Deblurring Real Image**
-------
##**1. Discription**
This project deblurring real image(e.g. image with motion blur and out-of-focus blur) quickly with PSF.
###**1.1 Motion Deblur**
For motion deblur, it uses **Lucy-Richardson** algorithm to estimate Point-Spread-Function(PSF). There are three main parameters to set: len(i.e. blur length), theta(i.e. blur angle) and IterNum(number of iteration times).
###**1.2 Out-of-focus Deblur**
For out-of-focus deblur, it uses **Wiener filter** algorithm. There are three main parameters to set:radius(i.e. the radius of Point-Spread-Function(PSF)), smooth(smooth factor to control **K**) and dering('On' means do suppress ringing effect while other means do not.

##**2. Usage**
1. Add the directory to the matlab path;
2. run 'Demo_motion_blur.m' to perform motion deblur;
3. run 'Demo_out_of_focus_deblur.m' to perform out-of-focus deblur.
