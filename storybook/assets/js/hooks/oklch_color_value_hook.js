export const OklchColorValue = {
  mounted() { 
   this.updateColorValue();
 },

 updateColorValue() {
   let theme = this.el.dataset.theme;
   let cssVar = this.el.dataset.cssVar;
   let closestSelector = `[data-theme="${theme}"]`;

   const closestContainer = this.el.closest(closestSelector);
   if (closestContainer) {
     const computedStyle = window.getComputedStyle(closestContainer);
     const backgroundColor = computedStyle.getPropertyValue(cssVar);

     if (backgroundColor) {
       this.el.textContent = backgroundColor;
       // Calculate text color based on background brightness
       this.updateTextColor(backgroundColor);

       // Create the oklch.com URL with the color values
       const oklchUrl = this.createOklchUrl(backgroundColor);
       this.el.href = oklchUrl;
     } else {
       this.el.textContent = 'N/A';
       this.el.href = '#';
     }
   }
 },

 updateTextColor(backgroundColor) {
   // Parse OKLCH directly for more reliable text color calculation
   const oklchMatch = backgroundColor.match(/oklch\(([^)]+)\)/);
   if (oklchMatch) {
     const values = oklchMatch[1].split(' ').map(v => v.trim());
     if (values.length >= 3) {
       let lightness = parseFloat(values[0]);
       if (values[0].includes('%')) {
         lightness = lightness / 100;
       }
       
       // Use OKLCH lightness directly for text color decision
       // OKLCH lightness of 0.5 is roughly middle gray
       // For very light colors (> 0.8), use black text
       // For very dark colors (< 0.2), use white text
       // For medium colors, use a threshold around 0.5
       let textColor;
       if (lightness > 0.8) {
         textColor = 'black';
       } else if (lightness < 0.2) {
         textColor = 'white';
       } else {
         textColor = lightness > 0.5 ? 'black' : 'white';
       }
       
       // console.log('Text color (OKLCH-based):', textColor);
       this.el.style.color = textColor;
       return;
     }
   }
   
   // Fallback to RGB-based calculation if OKLCH parsing fails
   const rgb = this.oklchToRgb(backgroundColor);
   if (!rgb) return;
   
   const luminance = this.calculateLuminance(rgb.r, rgb.g, rgb.b);
   
   // console.log('Fallback RGB:', rgb);
   // console.log('Fallback Luminance:', luminance);
   
   const textColor = luminance > 0.6 ? 'black' : 'white';
   // console.log('Fallback text color:', textColor);
   
   this.el.style.color = textColor;
 },

 oklchToRgb(oklchString) {
   // Parse OKLCH string like "oklch(0.97 0.014 254.604)" or "oklch(49.12% 0.3096 275.75)"
   const match = oklchString.match(/oklch\(([^)]+)\)/);
   if (!match) return null;
   
   const values = match[1].split(' ').map(v => v.trim());
   if (values.length < 3) return null;
   
   // Handle both percentage and decimal formats for lightness
   let l = parseFloat(values[0]);
   if (values[0].includes('%')) {
     l = l / 100; // Convert percentage to 0-1 range
   }
   // If l is already in 0-1 range, use as is
   
   const c = parseFloat(values[1]); // Chroma
   const h = parseFloat(values[2]); // Hue (degrees)
   
   // Convert OKLCH to RGB using a more accurate method
   const rgb = this.oklchToRgbAccurate(l, c, h);
   return rgb;
 },

 oklchToRgbAccurate(l, c, h) {
   // More accurate OKLCH to RGB conversion
   // Convert hue to radians
   const hRad = (h * Math.PI) / 180;
   
   // Calculate a and b components
   const a = c * Math.cos(hRad);
   const b = c * Math.sin(hRad);
   
   // Convert OKLCH to Lab (simplified)
   const labL = l;
   const labA = a;
   const labB = b;
   
   // Convert Lab to XYZ
   const xyz = this.labToXyz(labL, labA, labB);
   
   // Convert XYZ to RGB
   const rgb = this.xyzToRgb(xyz.x, xyz.y, xyz.z);
   
   return rgb;
 },

 labToXyz(l, a, b) {
   // Convert Lab to XYZ
   const fy = (l + 16) / 116;
   const fx = a / 500 + fy;
   const fz = fy - b / 200;
   
   const xr = fx > 0.206897 ? Math.pow(fx, 3) : (fx - 16/116) / 7.787;
   const yr = fy > 0.206897 ? Math.pow(fy, 3) : (fy - 16/116) / 7.787;
   const zr = fz > 0.206897 ? Math.pow(fz, 3) : (fz - 16/116) / 7.787;
   
   // D65 white point
   const x = xr * 0.95047;
   const y = yr * 1.00000;
   const z = zr * 1.08883;
   
   return { x, y, z };
 },

 xyzToRgb(x, y, z) {
   // Convert XYZ to RGB using sRGB color space
   const r = x *  3.2406 + y * -1.5372 + z * -0.4986;
   const g = x * -0.9689 + y *  1.8758 + z *  0.0415;
   const b = x *  0.0557 + y * -0.2040 + z *  1.0570;
   
   // Apply gamma correction and clamp values
   const gammaCorrect = (c) => {
     if (c <= 0.0031308) {
       return 12.92 * c;
     } else {
       return 1.055 * Math.pow(c, 1/2.4) - 0.055;
     }
   };
   
   const rCorrected = gammaCorrect(r);
   const gCorrected = gammaCorrect(g);
   const bCorrected = gammaCorrect(b);
   
   return {
     r: Math.max(0, Math.min(255, Math.round(rCorrected * 255))),
     g: Math.max(0, Math.min(255, Math.round(gCorrected * 255))),
     b: Math.max(0, Math.min(255, Math.round(bCorrected * 255)))
   };
 },

 calculateLuminance(r, g, b) {
   // Convert sRGB to linear RGB
   const rsRGB = r / 255;
   const gsRGB = g / 255;
   const bsRGB = b / 255;
   
   const rLinear = rsRGB <= 0.03928 ? rsRGB / 12.92 : Math.pow((rsRGB + 0.055) / 1.055, 2.4);
   const gLinear = gsRGB <= 0.03928 ? gsRGB / 12.92 : Math.pow((gsRGB + 0.055) / 1.055, 2.4);
   const bLinear = bsRGB <= 0.03928 ? bsRGB / 12.92 : Math.pow((bsRGB + 0.055) / 1.055, 2.4);
   
   // Calculate relative luminance
   return 0.2126 * rLinear + 0.7152 * gLinear + 0.0722 * bLinear;
 },

 createOklchUrl(oklchString) {
   // Parse OKLCH string like "oklch(0.97 0.014 254.604)" or "oklch(49.12% 0.3096 275.75)"
   const match = oklchString.match(/oklch\(([^)]+)\)/);
   if (!match) return 'https://oklch.com/';
   
   const values = match[1].split(' ').map(v => v.trim());
   if (values.length < 3) return 'https://oklch.com/';
   
   // Handle both percentage and decimal formats for lightness
   let l = parseFloat(values[0]);
   if (values[0].includes('%')) {
     // Already in percentage format
   } else {
     // Convert from 0-1 to 0-100 percentage
     l = l * 100;
   }
   
   const c = parseFloat(values[1]); // Chroma
   const h = parseFloat(values[2]); // Hue (degrees)
   
   // Format for oklch.com URL: https://oklch.com/#l,c,h,100
   return `https://oklch.com/#${l},${c},${h},100`;
 }
}
