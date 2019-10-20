#include <iostream>
#include <sstream>
#include <string>
#include "ddc.h"
#include "getopt_pp.h"

using namespace GetOpt;

void display_screens();
void display_help();

uint32_t num_displays = 0;
struct DDCDisplay *displayList;

int main(int argc, char* argv[]) {
	
	bool help_flag;
	bool set_flag;
	bool get_flag;
	std::string new_value;
	std::string display;
	std::string control;
    int new_value_int;
	int display_int;
	int control_int;
	
	
	bool list_displays;

	try
	{	
		GetOpt_pp ops(argc, argv);
		
		ops.exceptions(std::ios::failbit);
		
		ops 
		>> OptionPresent('h', "help", help_flag)
		>> OptionPresent('s', "set", set_flag)
		>> OptionPresent('g', "get", get_flag)
		
		>> OptionPresent('l', "listdisplays", list_displays)
		
		>> Option('c', "control", control)
		>> Option('v', "value", new_value, "0")
		>> Option('d', "display", display, "0")
		;
		
        displayList = DDCGetDisplayList(&num_displays);

		if (!ops.options_remain())
		{
			if ((help_flag) or ((set_flag+get_flag+list_displays) == 0) ) {
			    display_help();	
				return 0;
			}
			
			if ((set_flag + get_flag +  list_displays) != 1) {
				std::cerr << "Please specify only one of the following\n";
				std::cerr << "set | get | listcontrols | listdisplays \n";
	            return 1;
			}

			
			if (sscanf(new_value.c_str(), "%d", &new_value_int) == EOF) { std::cerr << "Value needs to be an integer\n"; return 1; }
			if (sscanf(display.c_str(), "%d", &display_int) == EOF) { std::cerr << "Display needs to be an integer\n"; return 1; }
            
            if (display_int < 0 || display_int >= num_displays || displayList[display_int].is_builtin) {
                std::cerr << "Display must be a valid entry";
                display_screens();
                return 1;
            }
            
            char *hex_pos;
            hex_pos = strcasestr(control.c_str(),"0x");
            if (hex_pos) {
                control_int = (int)strtol(hex_pos, NULL, 16);
            } else {
                control_int = (int)strtol(control.c_str(), NULL, 10);
            }
            
            if (list_displays) {
                display_screens();
                return 0;
            }
            
			if (set_flag) {
				if (!(ops >>OptionPresent('c',"control")) || !(ops >> OptionPresent('v',"value")) || !(ops >> OptionPresent('d',"display"))) {
					std::cerr << "Control,Value and Display need to be specified\n";
					return 1;
				}
                std::cout << "command:"
                << "\n  display: "<<display_int
                << "\n  control: "<<control_int
                << "\n  value: "<<new_value_int
                << "\n"
                ;

                int result;
				struct DDCWriteCommand write_command;
                write_command.control_id = control_int;
                write_command.new_value = new_value_int;
				result = DDCWrite(displayList[display_int].display_id, &write_command);
				return !result;
			}
			
			if (get_flag) {
				if (!(ops >>OptionPresent('c',"control"))  || !(ops >> OptionPresent('d',"display"))) {
					std::cerr << "Control and Display need to be specified\n";
					return 1;
				}
				
                std::cout << "command:"
                << "\n  display: "<<display_int
                << "\n  control: "<<control_int
                << "\n"
                ;

                int result;
				struct DDCReadCommand read_command;
				read_command.control_id = control_int;
				
                result = DDCRead(displayList[display_int].display_id, &read_command);

                std::cout << "Success: " << (int)read_command.success << "\n";
                std::cout << "Current Value: " << (int)read_command.current_value << "\n";
				std::cout << "Maximum Value: " << (int)read_command.max_value << "\n";
				
			}
			
			
			return 0;
		}
		else
		{
			std::cerr << "too many options" << std::endl;
			return 1;
		}
	}
	catch(const GetOptEx& e)
	{
		std::cerr << "Invalid options\n";
		std::cerr << "control should be a string\n";
		std::cerr << "value and display should be integers\n";
		display_help();
	}    
	
	return 0;
}

void display_screens() {
    std::cout << num_displays << " displays found:\n";
    for(int i = 0; i < num_displays; i++)
    {
        std::cout << "\t#" << i
        << " " << (displayList[i].name[0] ? displayList[i].name : "")
        <<" (" <<displayList[i].width<<"x"<<displayList[i].height
        <<(displayList[i].is_main ? " main" : "")
        <<(displayList[i].is_builtin ? " builtin: not usable" : "")
        <<")\n";
    }
}


void display_help() {
	std::cout << "Usage:\n"
    << "\t    ddcctrl --get -c <control value> -d <display value>\n"
    << "\t    ddcctrl --set -c <control value> -d <display value> -v <new value>\n"
    << "\t    ddcctrl --listdisplays\n"
    << "\n\n"
    ;
    display_screens();
}
