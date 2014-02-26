import std.stdio;
import std.array;
import std.conv;
import std.range;
import std.algorithm;
import options;
import operations;

File inputfile;
File outputfile;
DCalcOptions opt;
string[] current_group;
string[] prev_group;
string prev_line;
string[] input_headers;
size_t line_number=0;

void show_help()
{
	writeln("no Help yet.");
}

void open_files()
{
	if (opt.input_filename) {
		inputfile.open(opt.input_filename,"r");
	} else {
		opt.input_filename = "(stdin)";
		inputfile = stdin;
	}
	if (opt.output_filename) {
		outputfile.open(opt.output_filename,"w");
	} else {
		opt.output_filename = "(stdout)";
		outputfile = stdout;
	}
}

void close_files()
{
	inputfile.close();
	outputfile.close();
}

void print_header_line(const ref string[] fields)
{
	auto s1 = (opt.print_full_input_line)?
		(iota(1,fields.length+1,1).
		    map!( (x) => "input(" ~ input_headers[x-1] ~ ")").
		    join(opt.field_seperator)):
		(opt.group_fields.
		    map!( (x) => "groupby(" ~ input_headers[x-1] ~ ")").
		    join(opt.field_seperator));
	auto s2 = opt.operations.
		map!( (x) =>  x.name(input_headers) ).
		join(opt.field_seperator);
	outputfile.writeln(s1,opt.field_seperator,s2);
}

void print_group_results()
{
	auto s1 = (opt.print_full_input_line)?
			prev_line:
			prev_group.join(opt.field_seperator);
	auto s2 = opt.operations.
		map!( (x) => x.result ).
		join(opt.field_seperator);
	outputfile.writeln(s1,opt.field_seperator,s2);
}

bool set_current_group(ref string[] fields)
{
	if (!opt.group_fields.length)
		return false;

	//Ensure the input line has enough fields
	current_group = [];
	foreach (f; opt.group_fields) {
		if (f>fields.length)
			throw new OperationException("not enough input fields for group field "
					~ to!string(f) ~ ", found only " ~ to!string(fields.length)
					~ " field(s)");
		current_group ~= fields[f-1];
	}

	return (prev_group.length>0)
		&&
		(!equal(current_group, prev_group));
}

unittest
{
	writeln("Hello from UnitTest for ",__MODULE__);
}



version(unittest) {
void main()
{
}
} else { // version(unittest)
int main(string[] args)
{

	try {
		opt = parse_command_line(args);
		if (opt.show_help) {
			show_help();
			return 0;
		}

		open_files();

		auto line_reader = inputfile.byLine;

		/* Special handling for the first line - if there are headers */
		if (opt.input_header || opt.output_header) {
			auto line = line_reader.front.idup;
			auto fields = line.split(opt.field_seperator);

			/* If the first line was a header line, consume it.
			   If not - don't consume it, and the 'foreach' loop below will re-use it */
			if (opt.input_header) {
				input_headers = fields;
				line_reader.popFront();
				++line_number;
			} else {
				input_headers = iota(1,fields.length+1,1).
							map!(to!string).array();
			}

			/* Now we know how many fields are in the input file,
			   we can print the output header */
			if (opt.output_header)
				print_header_line(fields);
		}

		foreach (l; line_reader) {
			++line_number;
			auto line = l.idup;
			try {
				auto fields = line.split(opt.field_seperator);

				bool start_new_group = set_current_group(fields);

				if (start_new_group) {
					//Print Values of previous group
					print_group_results();

					//Reset operations
					foreach(op; opt.operations)
						op.reset;
				}

				foreach (op; opt.operations) {
					op.accumulate(fields);
				}

				prev_group = current_group;
				prev_line = line;

			} catch ( OperationException e) {
				//Add filename and line number and re-throw.
				throw new Exception( "Input error in '" ~
							opt.input_filename ~ "' line " ~
							to!string(line_number) ~ ": " ~ e.msg);
			}
		}

		//Print Values of last group
		print_group_results();

		close_files();
		return 0;
	} catch (Exception e) {
		string progname = args[0];
		stderr.writeln(progname ~ ": " ~ e.msg);
		return 1;
	}
}
} // not version(unittest)
