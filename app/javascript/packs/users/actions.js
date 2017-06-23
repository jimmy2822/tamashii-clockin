import {
  RECEIVE_ATTENDEES,
  START_REGISTER,
} from './constants';

import store from './store';

const ENDPOINTS = {
  attendees: () => `/users_admin.json`,
};

export const fetchAttendees = () => {
  $.get(ENDPOINTS.attendees())
   .promise()
   .done((data) => { store.dispatch({ type: RECEIVE_ATTENDEES, attendees: data }); });
};

export const startRegister = (attendeeId) => {
  store.dispatch({ type: START_REGISTER, attendeeId });
};

export default {
  fetchAttendees,
  startRegister,
};
