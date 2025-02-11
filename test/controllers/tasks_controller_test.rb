require "test_helper"

describe TasksController do
  let (:task) {
    Task.create name: "sample task", description: "this is an example for a test",
                completion_date: Time.now + 5.days
  }

# Tests for Wave 1
  describe "index" do
    it "can get the index path" do
      # Act
      get tasks_path

      # Assert
      must_respond_with :success
    end

    it "can get the root path" do
      # Act
      get root_path

      # Assert
      must_respond_with :success
    end
  end

  # Unskip these tests for Wave 2
  describe "show" do
    it "can get a valid task" do
      # Act
      get task_path(task.id)

      # Assert
      must_respond_with :success
    end

    it "will redirect for an invalid task" do
      # Act
      get task_path(-1)

      # Assert
      must_respond_with :redirect
    end
  end

  describe "new" do
    it "can get the new task page" do
      # Act
      get new_task_path

      # Assert
      must_respond_with :success
    end
  end

  describe "create" do
    it "can create a new task" do
      # Arrange
      task_hash = {
        task: {
          name: "new task",
          description: "new task description",
          completion_date: nil,
        },
      }

      # Act-Assert
      expect {
        post tasks_path, params: task_hash
      }.must_change "Task.count", 1

      new_task = Task.find_by(name: task_hash[:task][:name])
      expect(new_task.description).must_equal task_hash[:task][:description]
      expect(new_task.completion_date).must_equal task_hash[:task][:completion_date]

      must_respond_with :redirect
      must_redirect_to task_path(new_task.id)
    end
  end

  # Unskip and complete these tests for Wave 3
  describe "edit" do
    it "can get the edit page for an existing task" do
      # Act
      get edit_task_path(task.id)

      # Assert
      must_respond_with :success
    end


    it "will respond with redirect when attempting to edit a nonexistant task" do
      # Act
      get edit_task_path(-1)

      # Assert
      must_respond_with :redirect
    end
  end

  # Uncomment and complete these tests for Wave 3
  describe "update" do
    # Note:  If there was a way to fail to save the changes to a task, that would be a great
    #        thing to test.
    before do 
      @new_task = Task.create(name: "Test", description: "Created for testing", completion_date: nil)
    end 

    it "can update an existing task" do
      # Arrange
      original_task = Task.first
      original_task_updated = {
        task: {
          name: "Return",
          description: "items at Costco.",
          completion_date: nil
        },
      }
      
      # Act
      expect {
        patch task_path(original_task.id), params: original_task_updated
      }.wont_change 'Task.count'

      # Assert: 
      expect( Task.find_by(id: original_task.id).name ).must_equal "Return"
    end

    it "will redirect to the root page if given an invalid id" do
      # Act
      patch task_path(-1)

      # Assert
      must_respond_with :redirect    
    end
  end

  # Complete these tests for Wave 4
  describe "destroy" do
    before do 
      @new_task1 = Task.create(name: "Test", description: "Created for testing", completion_date: nil)
      @new_task2 = Task.create(name: "Test2", description: "Created for testing", completion_date: nil)
    end 

    it "will redirect to main page if task is deleted" do
      # Act
      delete task_path(task)

      # Assert
      must_respond_with :redirect 
    end

    it "will delete the task from database" do
      # Act 
      expect {
        delete task_path(@new_task1)
        delete task_path(@new_task2)
      }.must_change 'Task.count'
      # Assert
      expect( Task.all ).must_equal []
    end
  end

  # Complete for Wave 4
  describe "toggle_complete" do
    before do 
      @task_testing = Task.create(name: "Test", description: "Created for testing complete", completion_date: nil)
    end 
    it "will redirect to main page when task is marked as complete" do
      # Act
      put complete_task_path(@task_testing.id)
      # Assert
      must_respond_with :redirect
      must_redirect_to tasks_path
    end

    it "will not change the total number of tasks" do
      # Act-Assert
      expect {
        put complete_task_path(@task_testing.id)
      }.wont_change 'Task.count'    
    end

    it "will update the completion date to datetime when checked" do
      # Act
        put complete_task_path(@task_testing.id)
      # Assert
      expect( Task.find_by(id: @task_testing.id).completion_date ).wont_equal nil
      expect( Task.find_by(id: @task_testing.id).completion_date ).must_be_kind_of ActiveSupport::TimeWithZone
    end
  end
end
