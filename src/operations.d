module operations;

private import std.array,
		std.string,
		std.traits,
		std.conv,
		std.math,
		std.range,
		std.typecons,
		std.typetuple,
		std.exception,
		std.stdio,
		std.algorithm;

interface Operation
{
private:
	static const string sname() @property;
public:
	const string opname() const @property;
	const string name(const ref string[] field_names) const;
	const size_t num_fields() const @property;

	void setup_fields(ref string[] args);
	const size_t field() const @property;

	void reset();
	void add_value(const ref string str_value);
	void accumulate(const ref string[] input_fields);
	string result();
};

class OperationException : Exception
{
	this(string msg,string file=null, size_t line=0)
	{
		super(msg, file, line);
	}
};

alias available_operations = TypeTuple!(
	CountOperation,
	SumOperation,
	MinOperation,
	MaxOperation,
	AbsMinOperation,
	AbsMaxOperation,
	MeanOperation,
	MedianOperation,
	PopVarianceOperation,
	SampVarianceOperation,
	PopStdDevOperation,
	SampStdDevOperation,
	ConcatStringOperation,
	UniqueStringOperation);

Operation CreateOperation(const string opname)
{
	foreach (op; available_operations) {
		if (opname == op.sname) {
			return new op;
		}
	}
	throw new OperationException("Uknown operation '"~opname~"'");
}

unittest
{
	writeln("Hello from UnitTest for ",__MODULE__);
}

private {


class GenericOperation(T,
		       string _opname,
		       size_t _num_fields,
		       Flag!"CollectAllValues" collect_values,
		       alias add_value_function,
		       alias final_value_function) : Operation
{
private:
	size_t _field;
	size_t count;
	bool first_value = true;
	T current_value;
	T[] values;

public:
	this()
	{
		_field=0;
		reset();
	}

	this(const size_t _field)
	{
		this._field = _field;
		reset();
	}

	static const string sname() @property
	{
		return _opname;
	}

	const string opname() const @property
	{
		return _opname;
	}

	const size_t num_fields() const @property
	{
		return _num_fields;
	}

	void setup_fields(ref string[] args)
	{
		static if (_num_fields==0) {
			return ;
		} else {
			//At the moment, using more than one field is not implemented
			assert(_num_fields==1);

			if (args.length<1)
				throw new Exception("Operation '"~opname~"' requires one parameter: field number");
			try {
				_field = to!size_t(args[0]);
			} catch ( ConvException e ) {
				throw new Exception("Invalid parameter for operation '"
						~ opname ~ "' (" ~ args[0] ~ "): expecting numeric field number");
			}
			if (_field<=0)
				throw new Exception("Invalid field number for operation '"
						~ opname ~ "' (" ~ args[0] ~ "): must be numeric value >= 1");
			args = args[1..$];
		}
	}

	const string name(const ref string[] field_names) const
	{
		static if (_num_fields==0) {
			return opname;
		} else {

			//At the moment, using more than one field is not implemented
			assert(_num_fields==1);

			if (field_names.length<field)
				throw new Exception("Internal error for '" ~ opname ~ ".name(): need field " ~ to!string(field));

			return opname ~ "(" ~ field_names[field-1] ~ ")";
		}
	}

	const size_t field() const @property
	{
		return _field;
	}


	override void reset()
	{
		count = 0 ;
		first_value = true;
		current_value = T.init;
		values = [];
	}

	override void accumulate(const ref string fields[])
	{
		static if (_num_fields==0) {
			static string tmp = "0";
			add_value(tmp);
			return;
		} else {
			//At the moment, using more than one field is not implemented
			assert(_num_fields==1);

			if (fields.length<field)
				throw new OperationException("not enough input fields for operation '"
								~ opname ~ "', need "~ to!string(field)
								~ " fields but found " ~ to!string(fields.length));
			add_value(fields[field-1]);
		}
	}

	override void add_value(const ref string str_value)
	{
		T new_value;
		try {
			new_value = to!T(str_value);
		} catch ( ConvException ) {
			throw new OperationException("operation '"
							~ opname ~ "' expecting numeric value in field "
							~ to!string(field) ~ " but found '"
							~ str_value ~ "'");
		}

		static if (collect_values) {
			values ~= new_value;
		} else {
			++count;
			if (first_value) {
				current_value = new_value;
				first_value = false;
			} else {
				current_value = add_value_function( current_value, new_value ) ;
			}
		}
	}

	override string result()
	{
		static if (collect_values) {
			return to!string(
				final_value_function(values)
				);
		} else {
			return to!string(
				final_value_function(current_value, count)
				);
		}
	}
}

class CountOperation : GenericOperation!(double,
					"count",0,
					No.CollectAllValues,
					(current_value,new_value) => (0),
					(current_value,count) => (count))
{
}

class SumOperation : GenericOperation!( double,
					"sum",1,
					No.CollectAllValues,
					(current_value,new_value) => (current_value + new_value),
					(current_value,count) => (current_value))
{
}

class MeanOperation : GenericOperation!( double,
					"mean",1,
					 No.CollectAllValues,
					(current_value,new_value) => (current_value + new_value),
					(current_value,count) => (current_value / count))
{
}

class MaxOperation : GenericOperation!( double,
					"max",1,
					 No.CollectAllValues,
					(current_value,new_value) => (new_value>current_value?new_value:current_value),
					(current_value,count) => (current_value))
{
}

class AbsMaxOperation : GenericOperation!(double,
					 "absmax",1,
					 No.CollectAllValues,
					(current_value,new_value) => (abs(new_value)>abs(current_value)?new_value:current_value),
					(current_value,count) => (current_value))
{
}

class MinOperation : GenericOperation!( double,
					"min",1,
					 No.CollectAllValues,
					(current_value,new_value) => (new_value<current_value?new_value:current_value),
					(current_value,count) => (current_value))
{
}

class AbsMinOperation : GenericOperation!(double,
					 "absmin",1,
					 No.CollectAllValues,
					(current_value,new_value) => (abs(new_value)<abs(current_value)?new_value:current_value),
					(current_value,count) => (current_value))
{
}

double median(const double values[]) pure
{
	//TODO: is there a better alternative to ".dup" ?
	auto sorted = values.dup.sort;
	auto count = sorted.length;
	return ((count & 1)==0) ?
		((sorted[count/2-1] + sorted[count/2] ) / 2.0)
		:
		(sorted[count/2]);

}

class MedianOperation : GenericOperation!(double,
					 "median",1,
					 Yes.CollectAllValues,
					null,
					(values) => median(values)
					)
{
}

double variance(const double values[], const size_t df) pure
{
	double sum = 0;
	foreach (v; values)
		sum += v;

	double mean = sum / values.length;

	sum = 0 ;
	foreach (v; values)
		sum += (v - mean) * (v - mean);

	double variance = sum / ( values.length - df );

	return variance;
}

class PopStdDevOperation : GenericOperation!( double,
					 "pstdev",1,
					 Yes.CollectAllValues,
					null,
					(values) => sqrt(variance(values,0))
					)
{
}

class PopVarianceOperation : GenericOperation!( double,
					"pvar",1,
					 Yes.CollectAllValues,
					null,
					(values) => variance(values,0)
					)
{
}

class SampStdDevOperation : GenericOperation!( double,
					"sstdev",1,
					 Yes.CollectAllValues,
					null,
					(values) => sqrt(variance(values,1))
					)
{
}

class SampVarianceOperation : GenericOperation!( double,
						"svar",1,
					 Yes.CollectAllValues,
					null,
					(values) => variance(values,1)
					)
{
}

class ConcatStringOperation : GenericOperation!( string,
						"concat",1,
					 Yes.CollectAllValues,
					null,
					(values) => values.join(",")
					)
{
}



class UniqueStringOperation : GenericOperation!( string,
					"unique",1,
					 Yes.CollectAllValues,
					null,
					(values) => zip(values,repeat(true)).
							assocArray.
							keys.
							sort.
							join(",")
					)
{
}

} //private
