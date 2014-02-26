module options;

private import std.stdio,
	std.array,
	std.getopt,
	std.algorithm,
	std.conv,
	operations;

class DCalcOptions
{
	string field_seperator = "\t";
	bool print_full_input_line = false;
	bool output_header = false;
	bool input_header = false;
	bool show_help = false;
	string input_filename;
	string output_filename;
	size_t[] group_fields;
	Operation[] operations;
}

DCalcOptions parse_command_line(string[] args)
{
	DCalcOptions opt = new DCalcOptions;
	string groups;
	bool in_out_header = false;

	// Parse basic options
	try {
		getopt( args,
			std.getopt.config.caseSensitive,
			std.getopt.config.bundling,
			"field-seperator|t",  &opt.field_seperator,
			"full", &opt.print_full_input_line,
			"groups|g", &groups,
			"outheader|u", &opt.output_header,
			"inheader|U",  &opt.input_header,
			"header|H",    &in_out_header,
			"help|h",      &opt.show_help,
			"input|i",     &opt.input_filename,
			"output|o",    &opt.output_filename
		      );

		//Validate and split the "--groups=X,Y,Z" parameter
		try {
			opt.group_fields = groups.
						split(",").
						map!(to!size_t).
						array();
		} catch (ConvException e) {
			throw new Exception("Invalid --group value '" ~ groups ~ "'");
		}

		if (in_out_header)
			opt.input_header = opt.output_header = true;

		//Internally, STDIN and STDOUT are indicated by empty filenames.
		if (opt.input_filename == "-")
			opt.input_filename = "";
		if (opt.output_filename == "-")
			opt.output_filename = "" ;

		// The remaining parameters in 'args' are the operations
		auto ops = args;
		ops = ops[1..$];
		while (ops.length) {
			auto op_name = ops[0];
			ops = ops[1..$];
			Operation op = CreateOperation(op_name);
			op.setup_fields(ops);
			opt.operations ~= op;
		}

	} catch (Exception e) {
		throw new Exception("Failed to parse command line arguments: " ~ e.msg ~ ".\nSee --help for more information.");
	}

	return opt;
}

unittest
{
	writeln("Hello from UnitTest for ",__MODULE__);
}
