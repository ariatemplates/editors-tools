require! {

	'test/logger'

	'./proxy'
}

{Logger} = logger
{Proxyfier} = proxy

$logger = Logger!



# ------------------------------------------------------------------------------

$logger.separator 'Get'
$logger.on!

# proxy = Proxifier {\a \b \c}

# instance = Proxifier {
# 	a: 10
# 	b: 20
# }

# $logger.log instance.a
# $logger.log instance.b
# $logger.log instance.c

# $logger.log instance.a
# $logger.log instance.b
# $logger.log instance.foo
# instance.foo = 'foo'
# $logger.log instance.foo
# instance.bar = "hehehe"
# $logger.log instance.bar
# $logger.log instance.hello!
$logger.log 'Hello'
