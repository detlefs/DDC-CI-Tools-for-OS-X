//
//  controller.m
//
//  Created by Jonathan Taylor on 03/01/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "controller.h"
#import "ddc.h"

uint32_t num_displays = 0;
struct DDCDisplay *displayList;

@implementation controller

- (instancetype)init {
    if (self = [super init]) {
        displayList = DDCGetDisplayList(&num_displays);
    }
    return self;
}

- (void)setControlAndUpdateLabel:(int)control :(id)slider :(id)label {
	//[label takeIntValueFrom: slider];
	[self setLabelValue:label :[slider intValue]];
	[self setControlValue:control :[slider intValue]];
}

- (void)setSliderValue:(id)slider :(int)value {
	[slider setIntValue:value];
}

- (void)setLabelValue:(id)label :(int)value {
	[label setIntValue:value];
}

- (void)setControlValue:(int)control :(int)value {
	struct DDCWriteCommand write_command;                                                         
	write_command.control_id = control;
	write_command.new_value = value;
    DDCWrite(displayList[0].display_id, &write_command);
}


- (int)readControlValue:(int)control {
	struct DDCReadCommand read_command;
	read_command.control_id = control;

	DDCRead(displayList[0].display_id, &read_command);
	return ((int)read_command.current_value);
}

- (void)setControlsToCurrentValues{
	//Brightness
	int brightness_value = [self readControlValue:0x10];
	[self setSliderValue:brightnessSlider :brightness_value];
	[self setLabelValue:brightnessValueLabel :brightness_value];
	
	//Contrast
	int contrast_value = [self readControlValue:0x12];
	[self setSliderValue:contrastSlider :contrast_value];
	[self setLabelValue:contrastValueLabel :contrast_value];
	
    //Volume
    int volume_value = [self readControlValue:0x62];
    [self setSliderValue:volumeSlider :volume_value];
    [self setLabelValue:volumeValueLabel :volume_value];

    // Input Source
    int input_source = [self readControlValue:INPUT_SOURCE];
    switch (input_source) {
        case 0x0F:
            [radioButtonDP1 setState: NSControlStateValueOn];
            break;
        case 0x10:
            [radioButtonDP2 setState: NSControlStateValueOn];
            break;
        case 0x11:
            [radioButtonHDMI1 setState: NSControlStateValueOn];
            break;
        case 0x12:
            [radioButtonHDMI2 setState: NSControlStateValueOn];
            break;
        case 0x1B:
            [radioButtonUSBC setState: NSControlStateValueOn];
            break;
            
        default:
            break;
    }
}

- (IBAction)refreshClicked:(id)sender {
    [self setControlsToCurrentValues];
}

- (IBAction)setBrightness:(id)sender {
	[self setControlAndUpdateLabel:0x10 :sender :brightnessValueLabel];
}

- (IBAction)setContrast:(id)sender {
	[self setControlAndUpdateLabel:0x12 :sender :contrastValueLabel];
}

- (IBAction)setVolume:(id)sender {
    [self setControlAndUpdateLabel:0x62 :sender :volumeValueLabel];
}

- (IBAction)resetBrigthnessAndContrast:(id)sender {
    [self setControlValue:RESET_BRIGHTNESS_AND_CONTRAST :1];

    [self setControlsToCurrentValues];
}

- (IBAction)selectInputSource:(NSButton *)sender {
    
    int target_source = -1;
    if (sender == radioButtonDP1) {
        target_source = 0x0F;
    }
    else if (sender == radioButtonDP2) {
        target_source = 0x10;
    }
    else if (sender == radioButtonHDMI1) {
        target_source = 0x11;
    }
    else if (sender == radioButtonHDMI2) {
        target_source = 0x12;
    }
    else if (sender == radioButtonUSBC) {
        target_source = 0x1B;
    }

    if (target_source != -1) {
        [self setControlValue:INPUT_SOURCE :target_source];
    }
}

@end
