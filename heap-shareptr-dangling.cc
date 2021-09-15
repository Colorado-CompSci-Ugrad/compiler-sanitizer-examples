// To compile: g++ -O -g -fsanitize=address heap-use-after-free.cc
#include <stdio.h>
#include <stdlib.h>
#include <memory>

class SpeakUp {
  const char* say = "";
  int *array = NULL;
public:
  SpeakUp(const char* _say) {
    say = _say;
    array = new int[100];

    fprintf(stdout, "Created %s\n", say);
  }

  ~SpeakUp() {
    delete[] array;
    fprintf(stdout, "Deleted %s\n", say);
  }
};

int main(int argc, char **argv) {

  SpeakUp *not_shared_dangling = new SpeakUp("not shared heap allocated");
  std::shared_ptr<SpeakUp> shared_dangling( new SpeakUp("shared heap allocated") );

  fprintf(stdout, "The shared pointer will be garbage collected\n");
  fprintf(stdout, "The un-shared version will cause a leak error\n");
  fprintf(stdout, "but for some reason does not\n");

  return 0;
}
