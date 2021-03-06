require "test_helper"
require "jobs"

describe Jobs::ImageToBits do
  describe "converting to bits" do
    subject do
      Jobs::ImageToBits.image_data(fixture_path("8x8.png"))
    end

    it "includes the dimensions of the image" do
      subject[:width].must_equal 8
      subject[:height].must_equal 8
    end

    it "includes the pixel data for the image" do
      subject[:pixels].must_equal [1,0,0,0,0,0,0,0,
                                   0,1,0,0,0,0,0,0,
                                   0,0,1,0,0,0,0,0,
                                   0,0,0,1,0,0,0,0,
                                   0,0,0,0,1,0,0,0,
                                   0,0,0,0,0,1,0,0,
                                   0,0,0,0,0,0,1,0,
                                   0,0,0,0,0,0,0,1]
    end

    it "doesn't print transparent pixels" do
      data = Jobs::ImageToBits.image_data(fixture_path("8x8-transparent.png"))
      data[:pixels].must_equal [1,0,0,0,0,0,0,1] + [0]*(8*7)
    end
  end

  describe "performing" do
    it "puts the data into the printer" do
      data = {width: 8, height: 8, pixels: []}
      Jobs::ImageToBits.stubs(:image_data).with("file_path").returns(data)
      PrintQueue.stubs(:new).with("id").returns(queue = stub("print_queue"))
      queue.expects(:add_print_data).with(data)
      Jobs::ImageToBits.perform("file_path", "id")
    end
  end
end