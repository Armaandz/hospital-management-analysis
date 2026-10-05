# Business Insights — Hospital Management Analytics

Notes from analyzing a hospital dataset with 5 related tables
(patients, doctors, appointments, treatments, billing) using SQL
Server and Power BI.

## No-shows are a real problem, and it depends on the doctor

About 26% of appointments end up as a no-show. That's already a
big number, but the more interesting part is how much it varies by
doctor — even within the same specialization.

Two Pediatrics doctors show this clearly: Jane Davis has a no-show
rate of just 4.76%, while David Jones has 35.71%. Same specialty,
very different numbers. This suggests the issue isn't about which
type of doctor patients see, but something specific to each
doctor's process — maybe how appointments are scheduled, or whether
reminders go out consistently.

One more pattern worth mentioning: no-shows are noticeably higher
on Sundays than any other day (42.31%, well above the 26% overall
rate). Worth digging into further, but it points at something
schedule-related rather than random.

## Payment failures are high across the board, not tied to one method

I expected insurance payments to fail more often than cash or card,
but that's not really what the data shows. Failure rates are close
across all three payment methods — around 30-38%. Cash is
technically highest, but the gap is small enough that it's probably
not a meaningful difference given the sample size.

This points toward a more general billing process issue rather than
a problem specific to any one payment method.

## Chemotherapy has the most pending payments

Looking at treatment types, Chemotherapy has the highest share of
pending bills (about 41%). That kind of makes sense — it's likely
the most complex and expensive treatment to process through
insurance, so it probably just takes longer to resolve.

## Most patients see a doctor a handful of times, a few see them a lot more

Out of 50 patients, 2 have never had an appointment at all. On the
other end, one patient (Laura Davis) has 10 visits — about twice as
many as the next most frequent patient. Roughly a third of patients
are above the average visit count.

## If I were advising this hospital

Two things stand out as worth looking into first: figuring out
why no-show rates differ so much between doctors doing the same
type of work (there might be a process that's working well for one
doctor that could be applied more broadly), and reviewing the
billing workflow itself, since payment failures aren't isolated to
any one payment type.
