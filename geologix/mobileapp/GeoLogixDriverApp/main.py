# main.py

from kivy.app import App
from kivy.uix.boxlayout import BoxLayout
from kivy.uix.label import Label
from kivy.uix.button import Button
from kivy.uix.textinput import TextInput
from kivy.clock import Clock
import time

class DriverApp(App):
    def build(self):
        self.driver_rating = 0
        self.eth_balance = 0
        self.timer = None

        # Layout
        layout = BoxLayout(orientation='vertical')

        # Labels
        self.rating_label = Label(text="Rating: {}".format(self.driver_rating))
        self.eth_label = Label(text="ETH Balance: {}".format(self.eth_balance))

        # Text Inputs
        self.private_key_input = TextInput(hint_text="Enter private key")

        # Buttons
        sign_in_button = Button(text="Sign In")
        start_timer_button = Button(text="Start Timer")
        sign_out_button = Button(text="Sign Out")

        # Button Bindings
        sign_in_button.bind(on_press=self.sign_in)
        start_timer_button.bind(on_press=self.start_timer)
        sign_out_button.bind(on_press=self.sign_out)

        # Add Widgets to Layout
        layout.add_widget(self.private_key_input)
        layout.add_widget(sign_in_button)
        layout.add_widget(start_timer_button)
        layout.add_widget(sign_out_button)
        layout.add_widget(self.rating_label)
        layout.add_widget(self.eth_label)

        return layout

    def sign_in(self, instance):
        # Fetch driver's data (replace with actual fetching logic)
        self.driver_rating = 4.5
        self.eth_balance = 0.5

        # Update labels
        self.rating_label.text = "Rating: {}".format(self.driver_rating)
        self.eth_label.text = "ETH Balance: {}".format(self.eth_balance)

    def start_timer(self, instance):
        if self.timer is None:
            self.timer = Clock.schedule_interval(self.send_location_update, 300)  # Send location every 5 minutes

    def send_location_update(self, dt):
        # Get current location (replace with actual location retrieval logic)
        latitude, longitude = 0, 0

        # Send latitude and longitude to server (replace with actual sending logic)
        print("Sending location update - Latitude: {}, Longitude: {}".format(latitude, longitude))

    def sign_out(self, instance):
        if self.timer:
            self.timer.cancel()
            self.timer = None

        # Clear driver's data
        self.driver_rating = 0
        self.eth_balance = 0

        # Update labels
        self.rating_label.text = "Rating: {}".format(self.driver_rating)
        self.eth_label.text = "ETH Balance: {}".format(self.eth_balance)

if __name__ == '__main__':
    DriverApp().run()
