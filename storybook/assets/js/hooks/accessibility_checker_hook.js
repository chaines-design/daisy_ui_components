export const AccessibilityChecker = {
  mounted() {
    this.setupAccessibilityChecker();
  },

  setupAccessibilityChecker() {
    // Global functions for accessibility checking
    window.scanAllComponents = () => this.scanAllComponents();
    window.exportResults = (type) => this.exportResults(type);
    window.resetScanResults = () => this.resetScanResults();
    
    // Store results for export
    this.testResults = [];
    
    // Initialize theme detection
    this.updateThemeDisplay();
    
    console.log('Accessibility Checker initialized');
  },

  updateThemeDisplay() {
    const currentTheme = document.documentElement.getAttribute('data-theme') || 'light';
    const themeDisplay = currentTheme.charAt(0).toUpperCase() + currentTheme.slice(1);
    
    const themeBadge = document.getElementById('current-theme-badge');
    if (themeBadge) {
      themeBadge.textContent = `Testing in: ${themeDisplay} Mode`;
    }
    
    console.log('Current theme detected:', currentTheme);
  },

  scanAllComponents() {
    console.log('Starting accessibility scan...');
    
    // Update theme display before starting
    this.updateThemeDisplay();
    
    const scanButton = document.getElementById('scan-button');
    const exportButtons = [
      document.getElementById('export-summary'),
      document.getElementById('export-detailed')
    ];
    
    // Update button state
    scanButton.textContent = 'Scanning...';
    scanButton.disabled = true;
    
    // Clear previous results
    this.testResults = [];
    
    // Get all component test containers
    const testContainers = document.querySelectorAll('.component-test');
    
    let completedTests = 0;
    const totalTests = testContainers.length;
    
    console.log(`Found ${totalTests} tests to run`);
    console.log('Test containers:', Array.from(testContainers).map(c => ({
      id: c.id,
      component: c.dataset.component,
      debugIndex: c.dataset.debugIndex,
      classes: c.className
    })));
    
    testContainers.forEach((container, index) => {
      setTimeout(() => {
        // Use the debug index from the data attribute instead of loop index
        const testIndex = parseInt(container.dataset.debugIndex) || index;
        this.testComponent(container, testIndex, () => {
          completedTests++;
          
          if (completedTests === totalTests) {
            this.updateSummaryStats();
            
            scanButton.textContent = 'Scan All Components';
            scanButton.disabled = false;
            
            // Enable export buttons
            exportButtons.forEach(btn => {
              if (btn) btn.disabled = false;
            });
            
            // Show reset button
            const resetButton = document.getElementById('reset-button');
            if (resetButton) {
              resetButton.classList.remove('hidden');
            }
            
            console.log('Accessibility scan completed');
          }
        });
      }, index * 100); // Stagger tests to avoid overwhelming the browser
    });
  },

  testComponent(container, index, onComplete) {
    const component = container.dataset.component;
    const testElement = container.dataset.testElement;
    
    console.log(`Testing component ${index}: ${component}`);
    
    // Find the primary element to test based on component type
    let elementToTest = this.findElementToTest(container, component);
    
    if (!elementToTest) {
      console.warn(`Could not find element to test for component: ${component}`);
      console.log('Available elements in container:', container.innerHTML);
      this.showResult(index, null, 'Unable to find testable element');
      if (onComplete) onComplete();
      return;
    }
    
    console.log('Element to test:', elementToTest);
    
        // Small delay to ensure styles are fully applied
    setTimeout(() => {
      // Calculate contrast ratio
      const result = this.calculateContrastRatio(elementToTest, component);
      
      // Store result for export
      this.testResults.push({
        index,
        component,
        testElement,
        ...result
      });
      
      // Show result in UI
      this.showResult(index, result);
      
      // Show remediation if needed
      if (result.status === 'fail' || result.status === 'borderline') {
        this.showRemediation(index, result, component);
      }
      
      if (onComplete) onComplete();
    }, 50);
  },

  findElementToTest(container, component) {
    console.log('Finding element for component:', component);
    console.log('Container classes:', container.className);
    console.log('Container HTML:', container.innerHTML);
    console.log('Debug index:', container.dataset.debugIndex);
    
    // Different strategies for finding the right element to test
    let element = null;
    
    if (component.includes('Disabled')) {
      console.log('🔒 Processing disabled component:', component);
      console.log('🔒 Container HTML preview:', container.innerHTML.substring(0, 200) + '...');
      
      // First, try to find ANY disabled element regardless of component name
      console.log('🔒 Looking for any disabled element...');
      element = container.querySelector('button[disabled]') || 
                container.querySelector('input[disabled]') || 
                container.querySelector('select[disabled]');
      
      console.log('🔒 Found any disabled element:', element, 'disabled attr:', element?.disabled);
      
      // If no disabled attribute found, look for specific disabled classes or patterns
      if (!element) {
        console.log('🔒 No [disabled] attribute found, checking by content...');
        
        // Check if container contains button
        if (container.querySelector('button') || container.querySelector('.btn')) {
          console.log('🔒 Found button in container');
          element = container.querySelector('button') || container.querySelector('.btn');
        }
        // Check if container contains input
        else if (container.querySelector('input')) {
          console.log('🔒 Found input in container');
          element = container.querySelector('input');
        }
        // Check if container contains select
        else if (container.querySelector('select')) {
          console.log('🔒 Found select in container');
          element = container.querySelector('select');
        }
        
        console.log('🔒 Fallback element found:', element);
      }
      
      if (element) {
        console.log('🔒 Selected disabled element:', element.tagName, element.className);
        console.log('🔒 Element styles:', {
          opacity: window.getComputedStyle(element).opacity,
          color: window.getComputedStyle(element).color,
          backgroundColor: window.getComputedStyle(element).backgroundColor
        });
        console.log('🔒 RETURNING EARLY - should not see fallback logic');
        return element; // Return early to avoid fallback logic
      } else {
        console.log('🔒 No disabled element found, using fallback');
      }
    } else if (component.includes('Button')) {
      element = container.querySelector('button') || container.querySelector('.btn');
      console.log('Button element found:', element);
      console.log('Button element classes:', element ? element.className : 'none');
      console.log('Button element disabled state:', element ? element.disabled : 'none');
    } else if (component.includes('Alert')) {
      // For alerts, we want to test the text content, not the background
      element = container.querySelector('.alert span') || container.querySelector('.alert') || container.querySelector('[role="alert"]');
    } else if (component.includes('Badge')) {
      element = container.querySelector('.badge') || container.querySelector('.badge-outline') || container.querySelector('.badge-soft');
    } else if (component.includes('Input')) {
      element = container.querySelector('input') || container.querySelector('.input');
    } else if (component.includes('Select')) {
      element = container.querySelector('select') || container.querySelector('.select');
    } else if (component.includes('Textarea')) {
      element = container.querySelector('textarea') || container.querySelector('.textarea');
    } else if (component.includes('Checkbox') || component.includes('Radio') || component.includes('Toggle')) {
      // For form controls, test the label text or the element itself
      element = container.querySelector('.label-text') || container.querySelector('label') || 
                container.querySelector('input[type="checkbox"]') || container.querySelector('input[type="radio"]') ||
                container.querySelector('.toggle');
    } else if (component.includes('Link')) {
      element = container.querySelector('a') || container.querySelector('.link');
    } else if (component.includes('Menu')) {
      element = container.querySelector('.menu a') || container.querySelector('.menu li') || container.querySelector('.menu');
    } else if (component.includes('Range')) {
      element = container.querySelector('.range') || container.querySelector('input[type="range"]');
    }
    
    // If no specific element found, try common text-bearing elements
    if (!element) {
      const textElements = container.querySelectorAll('span, p, a, button, input, select, textarea, label, .label-text, div');
      for (let el of textElements) {
        const text = el.textContent.trim();
        if (text && text.length > 0) {
          element = el;
          break;
        }
      }
    }
    
    // Final fallback to the container itself
    if (!element) {
      element = container;
    }
    
    console.log('Selected element:', element);
    console.log('Selected element classes:', element ? element.className : 'none');
    console.log('Selected element computed style sample:', element ? {
      backgroundColor: window.getComputedStyle(element).backgroundColor,
      color: window.getComputedStyle(element).color,
      opacity: window.getComputedStyle(element).opacity,
      disabled: element.disabled
    } : 'none');
    
    return element;
  },

  calculateContrastRatio(element, component = '') {
    try {
      console.log('=== CONTRAST CALCULATION START ===');
      console.log('Testing element:', element);
      console.log('Element classes:', element.className);
      console.log('Component name:', component);
      
      const computedStyle = window.getComputedStyle(element);
      // More comprehensive disabled detection
      let isDisabled = false;
      let disabledSource = '';
      
      // Check the element itself
      if (element.disabled || element.hasAttribute('disabled')) {
        isDisabled = true;
        disabledSource = 'element disabled attribute';
      }
      
      // Check for disabled classes
      if (element.classList.contains('btn-disabled') || 
          element.classList.contains('input-disabled') ||
          element.classList.contains('select-disabled')) {
        isDisabled = true;
        disabledSource = 'element disabled class';
      }
      
      // Check if testing label for disabled input
      const parentLabel = element.closest('label');
      if (parentLabel) {
        const disabledInput = parentLabel.querySelector('input[disabled]') || parentLabel.querySelector('select[disabled]');
        if (disabledInput) {
          isDisabled = true;
          disabledSource = 'parent label contains disabled input';
        }
      }
      
             
       // Check if component name indicates disabled
       if (component && component.includes('Disabled')) {
         isDisabled = true;
         if (!disabledSource) disabledSource = 'component name indicates disabled';
       }
       
       // Check if we're in a disabled container
      if (element.closest('.btn-disabled') || element.closest('[disabled]')) {
        isDisabled = true;
        if (!disabledSource) disabledSource = 'parent element is disabled';
      }
      
      let backgroundColor = this.getBackgroundColor(element);
      let textColor = computedStyle.color;
      
      console.log('Colors found - Background:', backgroundColor, 'Text:', textColor);
      console.log('Element opacity:', computedStyle.opacity);
      console.log('Is disabled:', isDisabled, '- Source:', disabledSource);
      
      if (isDisabled) {
        console.log('🔒 DISABLED COMPONENT DETECTED!');
        console.log('🔒 Element:', element.tagName, element.className);
        console.log('🔒 Component:', component);
        console.log('🔒 Disabled source:', disabledSource);
      } else {
        console.log('❌ NOT detected as disabled');
        console.log('   Element disabled:', element.disabled);
        console.log('   Element classes:', element.className);
        console.log('   Component includes Disabled:', component ? component.includes('Disabled') : 'no component');
      }
      
      // Check for color-mix indicators in the classes
      const hasColorMix = this.detectColorMixUsage(element);
      if (hasColorMix) {
        console.log('🎨 COLOR-MIX DETECTED:', hasColorMix);
        console.log('Raw background color:', computedStyle.backgroundColor);
        console.log('Raw text color:', computedStyle.color);
      }
      
      // Special debugging for disabled elements
      if (isDisabled) {
        console.log('=== DISABLED ELEMENT DEBUG ===');
        console.log('Element:', element);
        console.log('Element type:', element.tagName);
        console.log('Computed style backgroundColor:', computedStyle.backgroundColor);
        console.log('Computed style color:', computedStyle.color);
        console.log('Computed style opacity:', computedStyle.opacity);
        console.log('Element disabled attr:', element.disabled);
        console.log('Parent elements:', element.parentElement);
        
        // Check if we're testing a label for a disabled input
        const disabledInput = element.closest('label')?.querySelector('input[disabled]');
        if (disabledInput) {
          console.log('Found disabled input in label:', disabledInput);
          console.log('Disabled input opacity:', window.getComputedStyle(disabledInput).opacity);
        }
        console.log('================================');
      }
      
      let bgRgb = this.parseColor(backgroundColor);
      let textRgb = this.parseColor(textColor);
      
      if (!bgRgb) {
        console.error('Failed to parse background color:', backgroundColor);
        return {
          ratio: null,
          status: 'error',
          message: `Could not parse background color: ${backgroundColor}`
        };
      }
      
      if (!textRgb) {
        console.error('Failed to parse text color:', textColor);
        return {
          ratio: null,
          status: 'error',
          message: `Could not parse text color: ${textColor}`
        };
      }
      
      // Handle alpha blending for semi-transparent colors (common with color-mix)
      if (bgRgb.a < 0.95) { // Slightly more lenient threshold to catch near-transparent colors
        const pageBackground = this.getPageBackgroundColor();
        console.log('🔄 Alpha-blending background:', bgRgb, 'over', pageBackground);
        bgRgb = this.blendColors(bgRgb, pageBackground);
        console.log('✅ Blended background color:', bgRgb);
      }
      
      if (textRgb.a < 0.95) { // Slightly more lenient threshold
        // For text, blend over the effective background (which might already be blended)
        const effectiveBackground = bgRgb.a < 0.95 ? this.getPageBackgroundColor() : bgRgb;
        console.log('🔄 Alpha-blending text:', textRgb, 'over effective background:', effectiveBackground);
        textRgb = this.blendColors(textRgb, effectiveBackground);
        console.log('✅ Blended text color:', textRgb);
      }
      
      // Handle disabled element opacity
      if (isDisabled) {
        // Check opacity at multiple levels - DaisyUI might apply it to parent elements
        let effectiveOpacity = parseFloat(computedStyle.opacity);
        let opacitySource = 'element itself';
        
        // Check parent elements for opacity
        let current = element.parentElement;
        let level = 1;
        while (current && level <= 3) { // Check up to 3 levels up
          const parentStyle = window.getComputedStyle(current);
          const parentOpacity = parseFloat(parentStyle.opacity);
          if (parentOpacity < 1.0) {
            effectiveOpacity *= parentOpacity;
            opacitySource += ` + parent level ${level} (${parentOpacity})`;
          }
          current = current.parentElement;
          level++;
        }
        
        console.log('🔒 Processing disabled element');
        console.log('   Element opacity:', computedStyle.opacity);
        console.log('   Effective opacity:', effectiveOpacity);
        console.log('   Opacity source:', opacitySource);
        
        if (effectiveOpacity < 0.99) { // Use slightly more lenient threshold
          const pageBackground = this.getPageBackgroundColor();
          
          // Apply opacity to both text and background colors by blending with page background
          console.log('🔄 Applying opacity to disabled element colors');
          console.log('   Original text color:', textRgb);
          console.log('   Original background color:', bgRgb);
          
          // Create color with reduced opacity
          const textWithOpacity = { ...textRgb, a: textRgb.a * effectiveOpacity };
          const bgWithOpacity = { ...bgRgb, a: bgRgb.a * effectiveOpacity };
          
          // Blend with page background to get final rendered colors
          textRgb = this.blendColors(textWithOpacity, pageBackground);
          bgRgb = this.blendColors(bgWithOpacity, pageBackground);
          
          console.log('✅ Final text color after opacity:', textRgb);
          console.log('✅ Final background color after opacity:', bgRgb);
                 } else {
           console.log('⚠️ No significant opacity found for disabled element');
           console.log('   Effective opacity was:', effectiveOpacity, '(threshold: 0.99)');
         }
      }
      
      // Additional logging for color-mix scenarios
      if (hasColorMix) {
        console.log('🎨 Final colors after color-mix processing:');
        console.log('   Background RGB:', bgRgb);
        console.log('   Text RGB:', textRgb);
      }
      
      const bgLuminance = this.getLuminance(bgRgb);
      const textLuminance = this.getLuminance(textRgb);
      
      console.log('Luminance values - Background:', bgLuminance, 'Text:', textLuminance);
      
      const ratio = this.getContrastRatio(bgLuminance, textLuminance);
      
      console.log('Calculated contrast ratio:', ratio);
      
      // Determine WCAG compliance
      const fontSize = parseFloat(computedStyle.fontSize);
      const fontWeight = computedStyle.fontWeight;
      const isLargeText = fontSize >= 18 || (fontSize >= 14 && (fontWeight === 'bold' || parseInt(fontWeight) >= 700));
      
      const threshold = isLargeText ? 3.0 : 4.5;
      
      let status;
      if (ratio >= threshold) {
        status = 'pass';
      } else if (ratio >= threshold - 0.5) {
        status = 'borderline';
      } else {
        status = 'fail';
      }
      
      console.log('Final result:', { ratio, status, threshold, isLargeText });
      console.log('=== CONTRAST CALCULATION END ===');
      
      return {
        ratio: ratio,
        status: status,
        isLargeText: isLargeText,
        threshold: threshold,
        backgroundColor: backgroundColor,
        textColor: textColor,
        fontSize: fontSize,
        fontWeight: fontWeight
      };
      
    } catch (error) {
      console.error('Error calculating contrast ratio:', error);
      return {
        ratio: null,
        status: 'error',
        message: error.message
      };
    }
  },

  getBackgroundColor(element) {
    let current = element;
    let backgroundColor = 'transparent';
    
    console.log('Finding background color for element:', element);
    console.log('Element tag:', element.tagName, 'classes:', element.className);
    
    // Special handling for text elements inside colored containers
    // If we're testing a span or text element, start from the parent
    if (element.tagName === 'SPAN' && element.parentElement && element.parentElement.classList.contains('alert')) {
      console.log('Testing alert text - starting from alert parent');
      current = element.parentElement;
    }
    
    // Walk up the DOM tree to find the first non-transparent background
    while (current && current !== document.documentElement) {
      const style = window.getComputedStyle(current);
      const bg = style.backgroundColor;
      
      console.log('Checking element:', current.tagName, current.className, 'Background:', bg);
      
      if (bg && bg !== 'rgba(0, 0, 0, 0)' && bg !== 'transparent' && bg !== 'initial' && bg !== 'inherit') {
        backgroundColor = bg;
        console.log('Found background color:', bg, 'on element:', current.tagName, current.className);
        break;
      }
      current = current.parentElement;
    }
    
    // If still transparent, check document body and html
    if (backgroundColor === 'transparent') {
      const bodyStyle = window.getComputedStyle(document.body);
      const bodyBg = bodyStyle.backgroundColor;
      
      if (bodyBg && bodyBg !== 'rgba(0, 0, 0, 0)' && bodyBg !== 'transparent') {
        backgroundColor = bodyBg;
        console.log('Using body background:', bodyBg);
      } else {
        const htmlStyle = window.getComputedStyle(document.documentElement);
        const htmlBg = htmlStyle.backgroundColor;
        
        if (htmlBg && htmlBg !== 'rgba(0, 0, 0, 0)' && htmlBg !== 'transparent') {
          backgroundColor = htmlBg;
          console.log('Using html background:', htmlBg);
        }
      }
    }
    
    // Default to white if no background found
    if (backgroundColor === 'transparent') {
      backgroundColor = 'rgb(255, 255, 255)';
      console.log('Defaulting to white background');
    }
    
    console.log('Final background color:', backgroundColor);
    return backgroundColor;
  },

  parseColor(colorString) {
    if (!colorString || colorString === 'transparent') {
      console.log('Transparent or invalid color:', colorString);
      return null;
    }
    
    console.log('Parsing color:', colorString);
    
    // Debug for very low alpha values that might cause 1:1 ratios
    if (colorString.includes('rgba') && colorString.includes('0.')) {
      console.log('*** LOW ALPHA COLOR DETECTED ***', colorString);
    }
    
    // Handle rgb() and rgba() colors
    const rgbMatch = colorString.match(/rgba?\(([^)]+)\)/);
    if (rgbMatch) {
      const values = rgbMatch[1].split(',').map(v => parseFloat(v.trim()));
      const result = {
        r: Math.max(0, Math.min(1, values[0] / 255)),
        g: Math.max(0, Math.min(1, values[1] / 255)),
        b: Math.max(0, Math.min(1, values[2] / 255)),
        a: values[3] !== undefined ? Math.max(0, Math.min(1, values[3])) : 1
      };
      console.log('Parsed RGB:', result);
      return result;
    }
    
    // Handle hex colors (both #ffffff and #fff formats)
    const hex6Match = colorString.match(/^#([a-f\d]{6})$/i);
    if (hex6Match) {
      const hex = hex6Match[1];
      const result = {
        r: parseInt(hex.substr(0, 2), 16) / 255,
        g: parseInt(hex.substr(2, 2), 16) / 255,
        b: parseInt(hex.substr(4, 2), 16) / 255,
        a: 1
      };
      console.log('Parsed 6-char hex:', result);
      return result;
    }
    
    const hex3Match = colorString.match(/^#([a-f\d]{3})$/i);
    if (hex3Match) {
      const hex = hex3Match[1];
      const result = {
        r: parseInt(hex[0] + hex[0], 16) / 255,
        g: parseInt(hex[1] + hex[1], 16) / 255,
        b: parseInt(hex[2] + hex[2], 16) / 255,
        a: 1
      };
      console.log('Parsed 3-char hex:', result);
      return result;
    }
    
    // Handle HSL colors
    const hslMatch = colorString.match(/hsla?\(([^)]+)\)/);
    if (hslMatch) {
      const values = hslMatch[1].split(',').map(v => v.trim());
      const h = parseFloat(values[0]) / 360;
      const s = parseFloat(values[1]) / 100;
      const l = parseFloat(values[2]) / 100;
      const a = values[3] !== undefined ? parseFloat(values[3]) : 1;
      
      const result = this.hslToRgb(h, s, l, a);
      console.log('Parsed HSL:', result);
      return result;
    }
    
    // Handle named colors (extended set)
    const namedColors = {
      'white': { r: 1, g: 1, b: 1, a: 1 },
      'black': { r: 0, g: 0, b: 0, a: 1 },
      'red': { r: 1, g: 0, b: 0, a: 1 },
      'green': { r: 0, g: 0.5, b: 0, a: 1 },
      'blue': { r: 0, g: 0, b: 1, a: 1 },
      'gray': { r: 0.5, g: 0.5, b: 0.5, a: 1 },
      'grey': { r: 0.5, g: 0.5, b: 0.5, a: 1 },
      'silver': { r: 0.75, g: 0.75, b: 0.75, a: 1 },
      'yellow': { r: 1, g: 1, b: 0, a: 1 },
      'cyan': { r: 0, g: 1, b: 1, a: 1 },
      'magenta': { r: 1, g: 0, b: 1, a: 1 },
      'orange': { r: 1, g: 0.65, b: 0, a: 1 }
    };
    
    const namedColor = namedColors[colorString.toLowerCase()];
    if (namedColor) {
      console.log('Parsed named color:', namedColor);
      return namedColor;
    }
    
    // Try using canvas to parse any other color format
    try {
      const canvas = document.createElement('canvas');
      canvas.width = 1;
      canvas.height = 1;
      const ctx = canvas.getContext('2d');
      
      ctx.fillStyle = colorString;
      ctx.fillRect(0, 0, 1, 1);
      
      const imageData = ctx.getImageData(0, 0, 1, 1);
      const data = imageData.data;
      
      const result = {
        r: data[0] / 255,
        g: data[1] / 255,
        b: data[2] / 255,
        a: data[3] / 255
      };
      console.log('Parsed via canvas:', result);
      return result;
    } catch (error) {
      console.warn('Canvas parsing failed for color:', colorString, error);
    }
    
    console.warn('Could not parse color:', colorString);
    return null;
  },

  hslToRgb(h, s, l, a = 1) {
    let r, g, b;

    if (s === 0) {
      r = g = b = l; // achromatic
    } else {
      const hue2rgb = (p, q, t) => {
        if (t < 0) t += 1;
        if (t > 1) t -= 1;
        if (t < 1/6) return p + (q - p) * 6 * t;
        if (t < 1/2) return q;
        if (t < 2/3) return p + (q - p) * (2/3 - t) * 6;
        return p;
      };

      const q = l < 0.5 ? l * (1 + s) : l + s - l * s;
      const p = 2 * l - q;
      r = hue2rgb(p, q, h + 1/3);
      g = hue2rgb(p, q, h);
      b = hue2rgb(p, q, h - 1/3);
    }

    return { r, g, b, a };
  },

  getLuminance(rgb) {
    // Convert sRGB to linear RGB
    const rsRGB = rgb.r;
    const gsRGB = rgb.g;
    const bsRGB = rgb.b;
    
    const toLinear = (colorChannel) => {
      if (colorChannel <= 0.03928) {
        return colorChannel / 12.92;
      } else {
        return Math.pow((colorChannel + 0.055) / 1.055, 2.4);
      }
    };
    
    const r = toLinear(rsRGB);
    const g = toLinear(gsRGB);
    const b = toLinear(bsRGB);
    
    // Calculate luminance
    return 0.2126 * r + 0.7152 * g + 0.0722 * b;
  },

  getContrastRatio(luminance1, luminance2) {
    const lighter = Math.max(luminance1, luminance2);
    const darker = Math.min(luminance1, luminance2);
    
    return (lighter + 0.05) / (darker + 0.05);
  },

  showResult(index, result, errorMessage = null) {
    console.log(`Showing result for index ${index}`);
    const resultContainer = document.getElementById(`result-${index}`);
    if (!resultContainer) {
      console.warn(`Could not find result container for index ${index}`);
      console.log('Available result containers:', Array.from(document.querySelectorAll('[id^="result-"]')).map(el => el.id));
      return;
    }
    
    resultContainer.classList.remove('hidden');
    
    const statusIndicator = resultContainer.querySelector('.contrast-status');
    const ratioText = resultContainer.querySelector('.contrast-ratio');
    const wcagStatus = resultContainer.querySelector('.wcag-status');
    
    if (errorMessage || result?.status === 'error') {
      statusIndicator.className = 'contrast-status w-3 h-3 rounded-full bg-gray-400';
      ratioText.textContent = 'Error';
      wcagStatus.textContent = errorMessage || result?.message || 'Test Error';
      wcagStatus.className = 'wcag-status text-xs font-medium px-2 py-1 rounded bg-gray-200 text-gray-700';
      return;
    }
    
    if (!result || result.ratio === null) {
      statusIndicator.className = 'contrast-status w-3 h-3 rounded-full bg-gray-400';
      ratioText.textContent = 'N/A';
      wcagStatus.textContent = 'Unable to test';
      wcagStatus.className = 'wcag-status text-xs font-medium px-2 py-1 rounded bg-gray-200 text-gray-700';
      return;
    }
    
    // Update ratio display
    ratioText.textContent = `${result.ratio.toFixed(1)}:1`;
    
    // Update status indicator and badge
    switch (result.status) {
      case 'pass':
        statusIndicator.className = 'contrast-status w-3 h-3 rounded-full bg-success';
        wcagStatus.textContent = `✓ WCAG AA`;
        wcagStatus.className = 'wcag-status text-xs font-medium px-2 py-1 rounded bg-success text-success-content';
        break;
      case 'borderline':
        statusIndicator.className = 'contrast-status w-3 h-3 rounded-full bg-warning';
        wcagStatus.textContent = '⚠ Borderline';
        wcagStatus.className = 'wcag-status text-xs font-medium px-2 py-1 rounded bg-warning text-warning-content';
        break;
      case 'fail':
        statusIndicator.className = 'contrast-status w-3 h-3 rounded-full bg-error';
        wcagStatus.textContent = '✗ WCAG Fail';
        wcagStatus.className = 'wcag-status text-xs font-medium px-2 py-1 rounded bg-error text-error-content';
        break;
    }
  },

  showRemediation(index, result, component) {
    const remediationContainer = document.getElementById(`remediation-${index}`);
    if (!remediationContainer) return;
    
    remediationContainer.classList.remove('hidden');
    const content = remediationContainer.querySelector('.remediation-content');
    
    const suggestions = this.getRemediationSuggestions(result, component);
    content.innerHTML = suggestions.map(suggestion => `<div>• ${suggestion}</div>`).join('');
  },

  getRemediationSuggestions(result, component) {
    const suggestions = [];
    const currentRatio = result.ratio.toFixed(1);
    const targetRatio = result.threshold;
    
    // Generic suggestions based on contrast ratio
    if (result.status === 'fail') {
      suggestions.push(`Current ratio ${currentRatio}:1 is below WCAG AA requirement of ${targetRatio}:1`);
    }
    
    // Component-specific suggestions
    if (component.includes('disabled')) {
      suggestions.push('Consider using text-base-content/60 instead of lower opacity values');
      suggestions.push('Ensure disabled states maintain minimum 3:1 contrast for accessibility');
      suggestions.push('Add visual indicators beyond color (icons, patterns) for disabled states');
    }
    
    if (component.includes('soft') || component.includes('8% opacity')) {
      suggestions.push('Replace 8% opacity backgrounds with solid colors that meet contrast requirements');
      suggestions.push('Consider using bordered variants instead of soft/transparent backgrounds');
    }
    
    if (component.includes('Link')) {
      suggestions.push('Ensure hover states maintain adequate contrast');
      suggestions.push('Consider adding underlines or other visual indicators for links');
    }
    
    if (component.includes('placeholder')) {
      suggestions.push('Use text-base-content/60 for placeholder text (minimum recommended)');
      suggestions.push('Consider providing helper text outside the input for important information');
    }
    
    // Text opacity suggestions
    if (result.textColor && result.textColor.includes('/20')) {
      suggestions.push('20% opacity text is too faint - use minimum 60% opacity');
    } else if (result.textColor && result.textColor.includes('/40')) {
      suggestions.push('40% opacity may be insufficient - consider 60% or higher');
    }
    
    // Fallback suggestions
    if (suggestions.length === 1) {
      suggestions.push('Increase text color darkness or background lightness');
      suggestions.push('Use high-contrast color combinations from your design system');
      suggestions.push('Test with screen readers and accessibility tools');
    }
    
    return suggestions;
  },

  updateSummaryStats() {
    const passing = this.testResults.filter(r => r.status === 'pass').length;
    const borderline = this.testResults.filter(r => r.status === 'borderline').length;
    const failing = this.testResults.filter(r => r.status === 'fail' || r.status === 'error').length;
    
    document.getElementById('passing-count').textContent = passing;
    document.getElementById('borderline-count').textContent = borderline;
    document.getElementById('failing-count').textContent = failing;
  },

  exportResults(type) {
    if (this.testResults.length === 0) {
      alert('No test results to export. Please run a scan first.');
      return;
    }
    
    let content;
    let filename;
    
    if (type === 'summary') {
      content = this.generateSummaryReport();
      filename = 'accessibility-summary.csv';
    } else {
      content = this.generateDetailedReport();
      filename = 'accessibility-detailed.csv';
    }
    
    this.downloadFile(content, filename);
  },

  generateSummaryReport() {
    const currentTheme = document.documentElement.getAttribute('data-theme') || 'light';
    
    const headers = ['Component', 'Status', 'Contrast Ratio', 'WCAG Threshold', 'Theme', 'Issue'];
    const rows = this.testResults.map(result => [
      result.component,
      result.status || 'error',
      result.ratio ? `${result.ratio.toFixed(1)}:1` : 'N/A',
      result.threshold ? `${result.threshold}:1` : 'N/A',
      currentTheme,
      result.testElement || ''
    ]);
    
    return [headers, ...rows].map(row => row.map(cell => `"${cell}"`).join(',')).join('\n');
  },

  generateDetailedReport() {
    const currentTheme = document.documentElement.getAttribute('data-theme') || 'light';
    
    const headers = [
      'Component', 'Status', 'Contrast Ratio', 'WCAG Threshold', 'Large Text',
      'Text Color', 'Background Color', 'Font Size', 'Font Weight', 'Theme', 'Timestamp', 'Issue'
    ];
    
    const rows = this.testResults.map(result => [
      result.component,
      result.status || 'error',
      result.ratio ? `${result.ratio.toFixed(1)}:1` : 'N/A',
      result.threshold ? `${result.threshold}:1` : 'N/A',
      result.isLargeText ? 'Yes' : 'No',
      result.textColor || 'N/A',
      result.backgroundColor || 'N/A',
      result.fontSize ? `${result.fontSize}px` : 'N/A',
      result.fontWeight || 'N/A',
      currentTheme,
      new Date().toISOString(),
      result.testElement || ''
    ]);
    
    return [headers, ...rows].map(row => row.map(cell => `"${cell}"`).join(',')).join('\n');
  },

  detectColorMixUsage(element) {
    const classes = element.className;
    const colorMixIndicators = [];
    
    // DaisyUI patterns that commonly use color-mix
    if (classes.includes('alert-soft')) colorMixIndicators.push('alert-soft (uses color-mix for transparency)');
    if (classes.includes('btn-disabled')) colorMixIndicators.push('btn-disabled (uses color-mix for opacity)');
    if (classes.includes('btn-ghost')) colorMixIndicators.push('btn-ghost (uses color-mix for hover states)');
    if (classes.includes('btn-outline')) colorMixIndicators.push('btn-outline (uses color-mix for fill transitions)');
    if (classes.includes('badge-soft')) colorMixIndicators.push('badge-soft (uses color-mix for transparency)');
    if (classes.includes('opacity-')) colorMixIndicators.push('opacity utility (may interact with color-mix)');
    
    // Check for hover-state classes that might use color-mix
    if (classes.includes('hover:bg-') || classes.includes('hover:text-')) {
      colorMixIndicators.push('forced hover state (may use color-mix)');
    }
    
    // Look for transparency in computed colors as additional indicator
    const computedStyle = window.getComputedStyle(element);
    const bgColor = computedStyle.backgroundColor;
    const textColor = computedStyle.color;
    
    if ((bgColor && bgColor.includes('rgba') && bgColor.includes('0.')) || 
        (bgColor && bgColor.includes('oklab') && bgColor.includes('/'))) {
      colorMixIndicators.push('semi-transparent background (likely color-mix result)');
    }
    
    if ((textColor && textColor.includes('rgba') && textColor.includes('0.')) ||
        (textColor && textColor.includes('oklch') && textColor.includes('/'))) {
      colorMixIndicators.push('semi-transparent text (likely color-mix result)');
    }
    
    return colorMixIndicators.length > 0 ? colorMixIndicators : null;
  },

  getPageBackgroundColor() {
    // Get the effective page background color
    const bodyStyle = window.getComputedStyle(document.body);
    const bodyBg = bodyStyle.backgroundColor;
    
    if (bodyBg && bodyBg !== 'rgba(0, 0, 0, 0)' && bodyBg !== 'transparent') {
      return this.parseColor(bodyBg) || { r: 1, g: 1, b: 1, a: 1 }; // fallback to white
    }
    
    const htmlStyle = window.getComputedStyle(document.documentElement);
    const htmlBg = htmlStyle.backgroundColor;
    
    if (htmlBg && htmlBg !== 'rgba(0, 0, 0, 0)' && htmlBg !== 'transparent') {
      return this.parseColor(htmlBg) || { r: 1, g: 1, b: 1, a: 1 }; // fallback to white
    }
    
    // Default to white background
    return { r: 1, g: 1, b: 1, a: 1 };
  },

  blendColors(foreground, background) {
    // Alpha blending: result = foreground * alpha + background * (1 - alpha)
    const alpha = foreground.a;
    const invAlpha = 1 - alpha;
    
    return {
      r: (foreground.r * alpha) + (background.r * invAlpha),
      g: (foreground.g * alpha) + (background.g * invAlpha), 
      b: (foreground.b * alpha) + (background.b * invAlpha),
      a: 1 // The blended result is opaque
    };
  },

  downloadFile(content, filename) {
    const blob = new Blob([content], { type: 'text/csv' });
    const url = window.URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = filename;
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    window.URL.revokeObjectURL(url);
  },

  resetScanResults() {
    console.log('Resetting scan results...');
    
    // Clear test results
    this.testResults = [];
    
    // Hide all result containers
    const resultContainers = document.querySelectorAll('[id^="result-"]');
    resultContainers.forEach(container => {
      container.classList.add('hidden');
    });
    
    // Hide all remediation containers
    const remediationContainers = document.querySelectorAll('[id^="remediation-"]');
    remediationContainers.forEach(container => {
      container.classList.add('hidden');
    });
    
    // Reset summary stats
    document.getElementById('passing-count').textContent = '-';
    document.getElementById('borderline-count').textContent = '-';
    document.getElementById('failing-count').textContent = '-';
    
    // Reset scan button state
    const scanButton = document.getElementById('scan-button');
    if (scanButton) {
      scanButton.textContent = 'Scan All Components';
      scanButton.disabled = false;
      // Re-add the icon
      scanButton.innerHTML = '<svg class="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path></svg> Scan All Components';
    }
    
    // Disable export buttons
    const exportButtons = [
      document.getElementById('export-summary'),
      document.getElementById('export-detailed')
    ];
    exportButtons.forEach(btn => {
      if (btn) btn.disabled = true;
    });
    
    // Hide reset button
    const resetButton = document.getElementById('reset-button');
    if (resetButton) {
      resetButton.classList.add('hidden');
    }
    
    console.log('Scan results reset successfully');
  }
}; 