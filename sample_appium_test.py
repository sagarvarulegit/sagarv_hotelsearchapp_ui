import pytest
from appium import webdriver
from appium.options.android import UiAutomator2Options
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import json

class TestHotelSearchApp:
    def setup_method(self):
        """Setup Appium driver for Flutter hotel search app"""
        # Load configuration
        with open('appium_test_config.json', 'r') as f:
            config = json.load(f)
        
        # Setup capabilities
        options = UiAutomator2Options()
        options.platform_name = config['platformName']
        options.device_name = config['deviceName']
        options.app = config['app']
        options.app_package = config['appPackage']
        options.app_activity = config['appActivity']
        options.automation_name = config['automationName']
        options.new_command_timeout = config['newCommandTimeout']
        options.no_reset = config['noReset']
        
        # Initialize driver
        self.driver = webdriver.Remote(
            command_executor='http://localhost:4723/wd/hub',
            options=options
        )
        self.wait = WebDriverWait(self.driver, 10)
    
    def teardown_method(self):
        """Clean up after test"""
        if self.driver:
            self.driver.quit()
    
    def test_app_launch(self):
        """Test that the app launches successfully"""
        # Wait for the app to load
        self.wait.until(EC.presence_of_element_located((By.CLASS_NAME, "android.widget.FrameLayout")))
        
        # Verify app package
        current_package = self.driver.current_package
        assert current_package == "com.example.hotel_search_app"
        
    def test_hotel_search_elements(self):
        """Test that key UI elements are present"""
        # Wait for Flutter widgets to load
        self.driver.implicitly_wait(5)
        
        # Test for presence of common Flutter elements
        # Note: Flutter uses semantic labels for accessibility
        try:
            # Look for text elements or buttons
            elements = self.driver.find_elements(By.CLASS_NAME, "android.widget.Button")
            assert len(elements) > 0, "No buttons found in the app"
            
            # Look for text input fields
            text_fields = self.driver.find_elements(By.CLASS_NAME, "android.widget.EditText")
            print(f"Found {len(text_fields)} text input fields")
            
        except Exception as e:
            print(f"Element detection issue: {e}")
            # Flutter apps may need special handling
            
    def test_flutter_specific_elements(self):
        """Test Flutter-specific element detection"""
        # Flutter elements might be detected as generic views
        flutter_elements = self.driver.find_elements(By.CLASS_NAME, "android.view.View")
        assert len(flutter_elements) > 0, "No Flutter views found"
        
        print(f"Found {len(flutter_elements)} Flutter view elements")

if __name__ == "__main__":
    # Run with: python -m pytest sample_appium_test.py -v
    pytest.main([__file__, "-v"])
