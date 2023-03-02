import sys
import random

def gen(num_of_records, filename):

	with open(filename,'w') as f:
		for i in range(1,int(num_of_records)+1):
			s = random.uniform(1,10)
			p = random.uniform(1,1000)
			f.write("%d,%d,%.2f\n" % (i,s,p))
	f.close()


if __name__ == "__main__":
	if len(sys.argv) > 2:
		sys.exit(gen(sys.argv[1],sys.argv[2]))
	else:
		print("USAGE: python3 generate.py <number_of_records> <file_name>")
